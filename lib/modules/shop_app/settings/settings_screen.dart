import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/shop_app/cubit/cubit.dart';
import 'package:training_app/layout/shop_app/cubit/states.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        nameController.text = model.data!.name;
        emailController.text = model.data!.email;
        phoneController.text = model.data!.phone;

        return ShopCubit.get(context).userModel != null?
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              defaultTextFormField(
                label: 'Name',
                controller: nameController,
                type: TextInputType.name,
                validator: (value){
                  if(value.isEmpty){
                    return 'name must not be empty';
                  }
                },
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
              const SizedBox(height: 15.0,),
              defaultTextFormField(
                label: 'Email',
                controller: emailController,
                type: TextInputType.emailAddress,
                validator: (value){
                  if(value.isEmpty){
                    return 'email must not be empty';
                  }
                },
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
              const SizedBox(height: 15.0,),
              defaultTextFormField(
                label: 'Phone',
                controller: phoneController,
                type: TextInputType.phone,
                validator: (value){
                  if(value.isEmpty){
                    return 'phone must not be empty';
                  }
                },
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
              const SizedBox(height: 20.0,),
              defaultButton(
                text: 'LOGOUT',
                function: (){
                  signOut(context);
                },
              ),
            ],
          ),):
        const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
