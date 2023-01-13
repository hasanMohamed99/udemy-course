import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/shop_app/shop_layout.dart';
import 'package:training_app/modules/shop_app/login/cubit/cubit.dart';
import 'package:training_app/modules/shop_app/login/cubit/states.dart';
import 'package:training_app/modules/shop_app/register/shop_register_screen.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatefulWidget {

  @override
  State<ShopLoginScreen> createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (BuildContext context, state) {
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status){
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data?.token,
              ).then((value) {
                token = state.loginModel.data?.token.toString();
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                text: state.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (BuildContext context, Object state) {
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
                          'login now to browse out hot offers',
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
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        state is! ShopLoginLoadingState? defaultButton(
                          text: 'login'.toUpperCase(),
                          function: (){
                            if(formKey.currentState!.validate()){
                              ShopLoginCubit.get(context).userLogin(
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
                                navigateTo(context, ShopRegisterScreen());
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
