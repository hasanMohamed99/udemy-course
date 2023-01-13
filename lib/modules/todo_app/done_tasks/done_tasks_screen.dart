import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/cubit/cubit.dart';
import 'package:training_app/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return tasks.isNotEmpty? ListView.separated(
          itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context,index) => Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
          itemCount: tasks.length,
        ) : tasksBuilder(tasks: tasks);
      },
    );
  }
}
