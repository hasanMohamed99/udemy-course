import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/news_app/news_layout.dart';
import 'package:training_app/layout/shop_app/cubit/cubit.dart';
import 'package:training_app/layout/shop_app/shop_layout.dart';
import 'package:training_app/layout/social_app/cubit/cubit.dart';
import 'package:training_app/layout/social_app/social_layout.dart';
import 'package:training_app/modules/native_code.dart';
import 'package:training_app/modules/shop_app/login/shop_login_screen.dart';
import 'package:training_app/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:training_app/modules/social_app/social_login/social_login_screen.dart';
import 'package:training_app/shared/bloc_observer.dart';
import 'package:training_app/layout/news_app/cubit/cubit.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/components/constants.dart';
import 'package:training_app/shared/cubit/cubit.dart';
import 'package:training_app/shared/cubit/states.dart';
import 'package:training_app/shared/network/local/cache_helper.dart';
import 'package:training_app/shared/network/remote/dio_helper.dart';
import 'package:training_app/shared/styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  if (kDebugMode) {
    print('on Background message');
    print(message.data.toString());
  }
  showToast(text: 'on Background message', state: ToastStates.SUCCESS);
}

void main() async {
  //بيتاكد ان كل حاجة هنا في الميثود خلصت وبعدين يفتح الابليكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('Token: $token');
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  // bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  // var token = CacheHelper.getData(key: 'token');
  // if(onBoarding != null){
  //   if(token !=null) {
  //     widget = ShopLayout();
  //   } else {
  //     widget = ShopLoginScreen();
  //   }
  // } else {
  //   widget = OnBoardingScreen();
  // }

  uId = CacheHelper.getData(key: 'uId');
  if(uId!=null){
    widget = const SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp( MyApp(isDark,widget,));
}

class MyApp extends StatelessWidget
{
  final bool? isDark;
  final Widget startWidget;

  const MyApp(this.isDark, this.startWidget, {super.key});

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NewsCubit()..getBusiness(),),
        BlocProvider(create: (context) => AppCubit()..changeAppMode(fromShared: isDark,),),
        BlocProvider(create: (context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),),
        BlocProvider(create: (context) => SocialCubit()..getUserData()..getPosts(),),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
       listener: (context, state) {},
       builder: (context, state) {
         return MaterialApp(
           debugShowCheckedModeBanner: false,
           theme: lightTheme,
           darkTheme: darkTheme,
           themeMode: AppCubit.get(context).isDark? ThemeMode.dark: ThemeMode.light,
           home: Directionality(
             textDirection: TextDirection.ltr,
             child: startWidget,
           ),
         );
       },
      ),
    );
  }
}