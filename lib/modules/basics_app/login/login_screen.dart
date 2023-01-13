import 'package:flutter/material.dart';
import 'package:training_app/shared/components/components.dart';


class LoginScreen extends StatefulWidget{

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color color = Colors.teal[300]!;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultTextFormField(
                    label: 'Email Address',
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validator: (value)
                    {
                      if(value!.isEmpty){
                        return 'email can\'t be empty';
                      }
                      return null;
                    },
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultTextFormField(
                    label: 'Password',
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    obscureText: isPasswordShow,
                    validator: (value)
                    {
                      if(value!.isEmpty){
                        return 'password can\'t be empty';
                      }
                      return null;

                    },
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: !isPasswordShow? const Icon(Icons.visibility) :const Icon(Icons.visibility_off),
                    suffixPressed: ()
                    {
                      setState(() {
                        isPasswordShow = !isPasswordShow;
                      });
                    }
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  defaultButton(
                    function: ()
                    {
                      if(formKey.currentState!.validate()){
                        print(emailController.text);
                        print(passwordController.text);
                      }
                    },
                    text: 'login'.toUpperCase(),
                    width: double.infinity,
                    backgroundColor: color,
                    radius: 30.0,
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have account?',
                      ),
                      TextButton(
                        onPressed: ()
                        {

                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: color,
                          ),
                        ),
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
  }
}