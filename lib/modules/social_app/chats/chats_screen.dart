import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/social_app/cubit/cubit.dart';
import 'package:training_app/layout/social_app/cubit/states.dart';
import 'package:training_app/models/social_app/social_user_model.dart';
import 'package:training_app/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/styles/colors.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SocialCubit.get(context).users.isEmpty?
        const Center(child: CircularProgressIndicator()):
        ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildChatItem(SocialCubit.get(context).users[index],context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: SocialCubit.get(context).users.length,
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(
        userModel: model,
      ),);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${model.image}',
            ),
          ),
          const SizedBox(width: 15.0,),
          Text(
            '${model.name}',
            style: const TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}
