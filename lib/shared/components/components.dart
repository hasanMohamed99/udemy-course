import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:training_app/modules/news_app/web_view/web_view_screen.dart';
import 'package:training_app/shared/cubit/cubit.dart';
import 'package:training_app/shared/styles/colors.dart';
import 'package:training_app/shared/styles/icon_broken.dart';

Widget defaultButton ({
  double width = double.infinity,
  double? height,
  Color backgroundColor = defaultColor,
  Color textColor = Colors.white,
  double radius = 0.0,
  required String text,
  @required function,
}) => Container(
  width: width,
  height: height,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
      radius,
    ),
    color: backgroundColor,
  ),
  child: MaterialButton(
    onPressed: function,
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
      ),
    ),
  ),
);

Widget defaultTextFormField({
  required String label,
  required TextEditingController controller,
  required TextInputType type,
  required validator,
  border, //OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
  bool obscureText = false,
  Icon? prefixIcon,
  Icon? suffixIcon,
  onFieldSubmitted,
  onChanged,
  suffixPressed,
  onTap,
  enabled,
}) => TextFormField(
  enabled: enabled,
  controller: controller,
  keyboardType: type,
  obscureText: obscureText,
  onFieldSubmitted: onFieldSubmitted,
  onChanged: onChanged,
  onTap: onTap,
  validator: validator,
  decoration: InputDecoration(
    border: border,
    labelText: label,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon != null ? IconButton(
        onPressed: suffixPressed,
        icon: suffixIcon,
    ): null,
  ),
);

PreferredSizeWidget defaultAppBar({required BuildContext context, String? title, List<Widget>? actions,}) =>AppBar(
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: const Icon(IconBroken.Arrow___Left_2),
  ),
  titleSpacing: 5.0,
  title: Text(title!),
  actions: actions,
);

Widget defaultTextButton({required function,required String text,}) => TextButton(
  onPressed: function,
  child: Text(text.toUpperCase()),
);

Widget buildTaskItem (Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteDatabase(id: model['id'],);
  },
  child:Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(

      children: [

        CircleAvatar(



          backgroundColor: Colors.teal[300],

          radius: 40.0,

          child: Text(

            '${model['time']}',

            style: const TextStyle(

              color: Colors.white,

            ),

          ),



        ),

        const SizedBox(

          width:20.0 ,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                '${model['title']}',

                style: const TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              const SizedBox(

                height: 15.0,

              ),

              Text(

                '${model['date']}',

                style: const TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        const SizedBox(

          width:20.0 ,

        ),

        IconButton(

          color: Colors.green,

          onPressed: (){

            AppCubit.get(context).updateDatabase(

              status: 'done',

              id: model['id'],

            );

          },

          icon: const Icon(Icons.check_box),),

        IconButton(

          color: Colors.black45,

          onPressed: (){

            AppCubit.get(context).updateDatabase(

              status: 'archive',

              id: model['id'],

            );

          },

          icon: const Icon(Icons.archive),),

      ],

    ),

  ),
);

Widget tasksBuilder ({required List<Map> tasks,}) => Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(
        Icons.menu,
        size: 100,
        color: Colors.grey,
      ),
      Text(
        'No Tasks Yet, Please Add Some Tasks',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ],
  ),
);

Widget myDivider() => Container(
  width: double.infinity,
  height: 1.0,
  color: Colors.grey[300],
);

Widget buildArticleItem(article, context) => InkWell(
  onTap: (){
    navigateTo(context, WebViewScreen(article['url']));
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0),

            image: DecorationImage(

              image: NetworkImage('${article["urlToImage"] ?? 'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg'}'),

              fit: BoxFit.cover,

            ),

          ),

        ),

        const SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Container(

            height: 120.0,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                Expanded(

                  child: Text(

                    '${article['title']}',

                    style: Theme.of(context).textTheme.bodyText1,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                  ),

                ),

                Text(

                  '${article['publishedAt']}',

                  style: const TextStyle(

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    ),

  ),
);

void navigateTo(context,Widget widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context,Widget widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),(Route<dynamic> route) => false,
);

void showToast ({required String text,required ToastStates state ,textColor}) => Fluttertoast.showToast(
  msg: text,
  textColor: Colors.white,
  backgroundColor: chooseToastColor(state),
  toastLength: Toast.LENGTH_LONG,
);

// ignore: constant_identifier_names
enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color =  Colors.amber;
      break;
  }
  return color;
}

