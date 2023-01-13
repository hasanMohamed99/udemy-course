import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/social_app/cubit/cubit.dart';
import 'package:training_app/layout/social_app/cubit/states.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = userModel!.name!;
        phoneController.text = userModel.phone!;
        bioController.text = userModel.bio!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              defaultTextButton(
                function: (){
                  SocialCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                text: 'UPDATE',
              ),
              const SizedBox(width: 15.0,),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 5.0,),
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null?
                                    NetworkImage(
                                      '${userModel.cover}',
                                    ):
                                    FileImage(coverImage) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null?
                                NetworkImage(
                                  '${userModel.image}',) :
                                FileImage(profileImage) as ImageProvider,
                                ),
                              ),
                            IconButton(
                              onPressed: (){
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  if(SocialCubit.get(context).profileImage != null ||SocialCubit.get(context).coverImage != null)
                    Row(
                    children: [
                      if(SocialCubit.get(context).profileImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              text: 'UPLOAD PROFILE',
                              function: (){
                                SocialCubit.get(context).uploadProfileImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                                SocialCubit.get(context).profileImage = null;
                              },
                            ),
                            if(state is SocialUserUpdateLoadingState)
                              const SizedBox(height: 5.0,),
                            if(state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5.0,),
                      if(SocialCubit.get(context).coverImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              text: 'UPLOAD COVER',
                              function: (){
                                SocialCubit.get(context).uploadCoverImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                                SocialCubit.get(context).coverImage = null;
                              },
                            ),
                            if(state is SocialUserUpdateLoadingState)
                              const SizedBox(height: 5.0,),
                            if(state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(SocialCubit.get(context).profileImage != null ||SocialCubit.get(context).coverImage != null)
                    const SizedBox(height: 20.0,),
                  defaultTextFormField(
                    label: 'Name',
                    controller: nameController,
                    type: TextInputType.name,
                    validator: (value){
                      if(value.isEmpty){
                        return 'name must not be empty';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(IconBroken.User),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                  const SizedBox(height: 10.0,),
                  defaultTextFormField(
                      label: 'Bio',
                      controller: bioController,
                      type: TextInputType.name,
                      validator: (value){
                        if(value.isEmpty){
                          return 'bio must not be empty';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(IconBroken.Info_Circle),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                  const SizedBox(height: 10.0,),
                  defaultTextFormField(
                      label: 'Phone',
                      controller: phoneController,
                      type: TextInputType.phone,
                      validator: (value){
                        if(value.isEmpty){
                          return 'phone must not be empty';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(IconBroken.Call),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
