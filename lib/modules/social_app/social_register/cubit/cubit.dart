import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/models/social_app/social_user_model.dart';
import 'package:training_app/modules/social_app/social_register/cubit/states.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates>{

  SocialRegisterCubit() : super(SocialRegisterInitialState());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }){
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      userCreate(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }){
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image: 'https://cdn-icons-png.flaticon.com/512/1159/1159740.png?w=740&t=st=1672932807~exp=1672933407~hmac=e2d73e801f69e8b24245266e8d510ffde24b032694a6eff80cea1988d6a4ba33',
      cover: 'https://img.freepik.com/free-photo/top-view-fast-food-mix-hamburger-doner-sandwich-chicken-nuggets-rice-vegetable-salad-chicken-sticks-caesar-salad-mushrooms-pizza-chicken-ragout-french-fries-mayo_141793-3997.jpg?w=826&t=st=1672936494~exp=1672937094~hmac=4b3f52f4de6bf5a0ff1f35249305611031ba9a25fe8282ff27248e4b4eb28913',
      bio: 'write your bio ...',
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
          emit(SocialCreateUserSuccessState());
    }).catchError((error){
      emit(SocialCreateUserErrorState(error));
    });
  }
}