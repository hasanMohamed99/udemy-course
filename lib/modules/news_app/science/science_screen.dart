import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/news_app/cubit/cubit.dart';
import 'package:training_app/layout/news_app/cubit/states.dart';
import 'package:training_app/shared/components/components.dart';

class ScienceScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state) {},
      builder: (context,state) {
        var list = NewsCubit.get(context).science;
        return list.isEmpty?
        const Center(child: CircularProgressIndicator(color: Colors.teal,)) :
        ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildArticleItem(list[index],context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: list.length,
        );
      },
    );
  }
}
