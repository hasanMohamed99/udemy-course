import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/modules/social_app/social_login/cubit/states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates>{

  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);


  void userLogin({
    required String email,
    required String password,
  }){
    emit(SocialLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      if (kDebugMode) {
        print(value.user!.email);
        print(value.user!.uid);
      }
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){

      emit(SocialLoginErrorState(error.toString()));
    });
  }
}