import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:training_app/layout/social_app/cubit/states.dart';
import 'package:training_app/models/social_app/message_model.dart';
import 'package:training_app/models/social_app/post_model.dart';
import 'package:training_app/models/social_app/social_user_model.dart';
import 'package:training_app/models/user/user_model.dart';
import 'package:training_app/modules/social_app/chats/chats_screen.dart';
import 'package:training_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:training_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:training_app/modules/social_app/settings/settings_screen.dart';
import 'package:training_app/modules/social_app/social_register/cubit/states.dart';
import 'package:training_app/modules/social_app/users/users_screen.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates>{
  SocialCubit() : super(SocialInitialState());
  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel? userModel;
  void getUserData(){
    emit(SocialGetUserLoadingState());
    
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
          userModel = SocialUserModel.fromJson(value.data()!);
          emit(SocialGetUserSuccessState());
    })
        .catchError((error){
          if (kDebugMode) {
            print(error.toString());
          }
          emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex =0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = const [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changesBottomNav(int index){

    if(index == 1) {
      getUsers();
    }
    if(index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  Future<void> getProfileImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(image != null){
      profileImage = File(image.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      showToast(text: 'No image selected', state: ToastStates.WARNING);
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;
  Future<void> getCoverImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(image != null){
      coverImage = File(image.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      showToast(text: 'No image selected', state: ToastStates.WARNING);
      emit(SocialCoverImagePickedErrorState());
    }

  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }){
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error){
        emit(SocialUploadProfileImageErrorState());
      });
    })
        .catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }){
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error){
        emit(SocialUploadCoverImageErrorState());
      });
    })
        .catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
  }

  // void updateUserImages({
  //   required String name,
  //   required String phone,
  //   required String bio,
  // }){
  //   emit(SocialUserUpdateLoadingState());
  //   if(coverImage!= null){
  //     uploadCoverImage(name: name, phone: phone, bio: bio);
  //   } else if(profileImage!= null){
  //     uploadProfileImage(name: name, phone: phone, bio: bio);
  //   } else if(coverImage!= null && profileImage!= null){
  //
  //   }
  //   else {
  //     updateUser(
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //     );
  //   }
  // }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }){
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      email: userModel?.email,
      image: image??userModel?.image,
      cover: cover??userModel?.cover,
      uId: userModel?.uId,
      bio: bio,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    })
        .catchError((error){
      emit(SocialUserUpdateErrorState());
    });
  }


  File? postImage;
  Future<void> getPostImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(image != null){
      postImage = File(image.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      showToast(text: 'No image selected', state: ToastStates.WARNING);
      emit(SocialCoverImagePickedErrorState());
    }

  }

  void removePostImage(){
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }){
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((error){
        emit(SocialCreatePostErrorState());
      });
    })
        .catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }){
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel?.name,
      image: userModel?.image,
      uId: userModel?.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage??'',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          emit(SocialCreatePostSuccessState());
    })
        .catchError((error){
      if (kDebugMode) {
        print(error);
      }
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts =[];
  List<String> postsId =[];
  List<int> likes =[];
  void getPosts(){

    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value) {
          for (var element in value.docs) {
            element.reference
                .collection('likes')
                .get()
                .then((value) {
                  likes.add(value.docs.length);
                  postsId.add(element.id);
                  posts.add(PostModel.fromJson(element.data()));
                })
                .catchError((error){});

          }
          emit(SocialGetPostsSuccessState());
    })
        .catchError((error){
          emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel?.uId)
        .set({
      'like': true,
    })
        .then((value) {
          emit(SocialLikePostSuccessState());
        })
        .catchError((error){
          emit(SocialLikePostErrorState(error.toString()));
        });
  }

  List<SocialUserModel> users = [];

  void getUsers(){
    if(users.isEmpty) {
      FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if(element.data()['uId'] != userModel?.uId){
          users.add(SocialUserModel.fromJson(element.data()));
        }
      }
      emit(SocialGetAllUsersSuccessState());
    })
        .catchError((error){
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }){
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel?.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
          emit(SocialSendMessageSuccessState());
        })
        .catchError((error){
          emit(SocialSendMessageErrorState());
        });

    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel?.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error){
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({
    required String receiverId,
  }){
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
          for (var element in event.docs) {
            messages.add(MessageModel.fromJson(element.data()));
          }
          emit(SocialGetMessagesSuccessState());
        });
  }
}