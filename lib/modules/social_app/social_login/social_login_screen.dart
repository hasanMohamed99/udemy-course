import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/social_app/social_layout.dart';
import 'package:training_app/modules/social_app/social_login/cubit/cubit.dart';
import 'package:training_app/modules/social_app/social_login/cubit/states.dart';
import 'package:training_app/modules/social_app/social_register/social_register_screen.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/network/local/cache_helper.dart';

class SocialLoginScreen extends StatefulWidget {

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
        listener: (context, state) {

          if(state is SocialLoginErrorState){
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }

          if(state is SocialLoginSuccessState){
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              navigateAndFinish(context, const SocialLayout());
            });
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'login now to communicate with friends',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          label: 'Email Address',
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validator: (value){
                            if(value.isEmpty){
                              return 'please enter your email address';
                            }
                          },
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextFormField(
                          label: 'Password',
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          obscureText: isPasswordShow,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'password can\'t be empty';
                            }
                            return null;
                          },
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: !isPasswordShow? const Icon(Icons.visibility) :const Icon(Icons.visibility_off),
                          suffixPressed: () {
                            setState(() {
                              isPasswordShow = !isPasswordShow;
                            });
                          },
                          onFieldSubmitted: (String value){
                            if(formKey.currentState!.validate()){
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        state is! SocialLoginLoadingState? defaultButton(
                          text: 'login'.toUpperCase(),
                          function: (){
                            if(formKey.currentState!.validate()){
                              SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ) : const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                              function: ()
                              {
                                navigateTo(context, SocialRegisterScreen());
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}