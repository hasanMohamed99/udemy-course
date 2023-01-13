import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/shop_app/shop_layout.dart';
import 'package:training_app/modules/shop_app/login/cubit/cubit.dart';
import 'package:training_app/modules/shop_app/register/cubit/cubit.dart';
import 'package:training_app/modules/shop_app/register/cubit/states.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/network/local/cache_helper.dart';

class ShopRegisterScreen extends StatefulWidget {

  @override
  State<ShopRegisterScreen> createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener: (BuildContext context, state) {

          if(state is ShopRegisterSuccessState){
            if(state.loginModel.status){
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data?.token,
              ).then((value) {
                token = state.loginModel.data?.token;
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
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          label: 'Name',
                          controller: nameController,
                          type: TextInputType.text,
                          validator: (value){
                            if(value.isEmpty){
                              return 'please enter your name';
                            }
                          },
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                        ),
                        const SizedBox(
                          height: 15.0,
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
                          label: 'phone',
                          controller: phoneController,
                          type: TextInputType.phone,
                          validator: (value){
                            if(value.isEmpty){
                              return 'please enter your phone number';
                            }
                          },
                          prefixIcon: const Icon(Icons.phone_android_outlined),
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
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        state is! ShopRegisterLoadingState? defaultButton(
                          text: 'register'.toUpperCase(),
                          function: (){
                            if(formKey.currentState!.validate()){
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                        ): const Center(child: CircularProgressIndicator()), //: const Center(child: CircularProgressIndicator()),
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
