import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/shop_app/cubit/states.dart';
import 'package:training_app/models/shop_app/categories_model.dart';
import 'package:training_app/models/shop_app/change_favorites_model.dart';
import 'package:training_app/models/shop_app/favorites_model.dart';
import 'package:training_app/models/shop_app/home_model.dart';
import 'package:training_app/models/shop_app/login_model.dart';
import 'package:training_app/modules/shop_app/categories/categories_screen.dart';
import 'package:training_app/modules/shop_app/favorites/favorites_screen.dart';
import 'package:training_app/modules/shop_app/products/products_screen.dart';
import 'package:training_app/modules/shop_app/settings/settings_screen.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/network/end_points.dart';
import 'package:training_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens =[
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index){
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData(){
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      }
      emit(ShopSuccessHomeDataState());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorHomeDataState());
    });

  }

  CategoriesModel? categoriesModel;

  void getCategories(){

    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorCategoriesState());
    });

  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId){

    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data!);
      if(!changeFavoritesModel!.status){
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error){
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites(){

    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {

      favoritesModel = FavoritesModel.fromJson(value.data!);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorGetFavoritesState());
    });

  }

  late ShopLoginModel userModel;

  void getUserData(){

    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {

      userModel = ShopLoginModel.fromJson(value.data);
      if (kDebugMode) {
        print('User: ${userModel.data?.name}');
      }

      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorUserDataState());
    });

  }
}