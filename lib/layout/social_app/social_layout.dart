import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/social_app/cubit/cubit.dart';
import 'package:training_app/layout/social_app/cubit/states.dart';
import 'package:training_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialNewPostState)
          {
            navigateTo(context, NewPostScreen());
          }
      },
      builder: (context, state) {

        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                onPressed: (){},
                icon: const Icon(IconBroken.Notification),
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(IconBroken.Search),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changesBottomNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(
                  IconBroken.Home,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Chats',
                icon: Icon(
                  IconBroken.Chat,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Post',
                icon: Icon(
                  IconBroken.Paper_Upload,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Users',
                icon: Icon(
                  IconBroken.Location,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(
                  IconBroken.Setting,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
