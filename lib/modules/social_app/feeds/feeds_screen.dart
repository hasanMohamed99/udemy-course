import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/social_app/cubit/cubit.dart';
import 'package:training_app/layout/social_app/cubit/states.dart';
import 'package:training_app/models/social_app/post_model.dart';
import 'package:training_app/shared/styles/colors.dart';
import 'package:training_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SocialCubit.get(context).posts.isEmpty && SocialCubit.get(context).userModel != null?
        const Center(child: CircularProgressIndicator()):
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 10.0,
                margin: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    const Image(
                      image: NetworkImage(
                        'https://img.freepik.com/free-photo/impressed-surprised-man-points-away-blank-space_273609-40694.jpg?w=740&t=st=1672925814~exp=1672926414~hmac=a75e89fe9fca68a79a11ce846673723a6b8c4cf05c76a11b80741a2db5051ab5',
                      ),
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'communicate with friends',
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => buildPostItem(SocialCubit.get(context).posts[index], context, index),
                separatorBuilder: (context, index) => const SizedBox(height: 8.0,),
                itemCount: SocialCubit.get(context).posts.length,
              ),
              const SizedBox(height: 8.0,),
            ],
          ),
        );
      },
    );
  }

  Widget buildPostItem(PostModel model, context, index) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
              ),
              const SizedBox(width: 15.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          model.name.toString(),
                          style: const TextStyle(
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(width: 5.0,),
                        const Icon(
                          Icons.check_circle,
                          color: defaultColor,
                          size: 16.0,
                        ),
                      ],
                    ),
                    Text(
                      model.dateTime.toString(),
                      style: Theme.of(context).textTheme.caption?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15.0,),
              IconButton(
                onPressed: (){},
                icon: const Icon(
                  Icons.more_horiz,
                  size: 16.0,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Text(
            model.text.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       bottom: 10.0,
          //       top: 5.0
          //   ),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: Wrap(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end:6.0),
          //           child: SizedBox(
          //             height: 20.0,
          //             child: MaterialButton(
          //               onPressed: (){},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: const Text(
          //                 '#software',
          //                 style: TextStyle(
          //                   color: defaultColor,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end:6.0),
          //           child: SizedBox(
          //             height: 20.0,
          //             child: MaterialButton(
          //               onPressed: (){},
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               child: const Text(
          //                 '#flutter',
          //                 style: TextStyle(
          //                   color: defaultColor,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          if(model.postImage != '')
            Padding(
            padding: const EdgeInsetsDirectional.only(top: 5.0),
            child: Container(
              height: 140.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                image: DecorationImage(
                  image: NetworkImage(
                    '${model.postImage}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.Heart,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 5.0,),
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: (){

                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            IconBroken.Chat,
                            size: 16.0,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 5.0,),
                          Text(
                            '0',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      //SocialCubit.get(context).likePost(model)
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel?.image}',
                        ),
                      ),
                      const SizedBox(width: 15.0,),
                      Text(
                        'write a comment ...',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  onTap: (){},
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    const Icon(
                      IconBroken.Heart,
                      size: 16.0,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 5.0,),
                    Text(
                      'like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                },
              )
            ],
          ),
        ],
      ),
    ),
  );
}
