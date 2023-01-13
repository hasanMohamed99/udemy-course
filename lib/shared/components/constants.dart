import 'package:training_app/modules/shop_app/login/shop_login_screen.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/network/local/cache_helper.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if(value ){
      navigateAndFinish(context,ShopLoginScreen());
    }
  });
}

void printFullText(String text){
  final pattern = RegExp('.{1800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String? token = '';
String? uId = '';