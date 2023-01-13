import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/cubit/cubit.dart';
import 'package:training_app/shared/cubit/states.dart';

// 1. create database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. update database
// 7. delete database


class HomeLayout extends StatelessWidget {
  Color color = Colors.teal[300]!;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Task added successfully',
              textColor: Colors.white,
              backgroundColor: color,
              toastLength: Toast.LENGTH_LONG,
            );
            titleController.clear();
            dateController.clear();
            timeController.clear();
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: color,
              title: Center(
                child: Text(
                  cubit.titles[cubit.currentIndex],
                ),
              ),
            ),
            body: state is AppGetDatabaseLoadingState? const Center(child: CircularProgressIndicator()) : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: color,
              onPressed: ()
              {
                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                  }
                } else
                {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormField(
                              label: 'Task Title',
                              controller: titleController,
                              type: TextInputType.text,
                              validator: (value) {
                                if(value.isEmpty) {
                                  return 'title must not be empty';
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.title),
                              border: const OutlineInputBorder(),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultTextFormField(
                              label: 'Task Time',
                              controller: timeController,
                              type: TextInputType.none,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value!.format(context).toString();
                                });
                              },
                              validator: (value) {
                                if(value.isEmpty) {
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.watch_later_outlined),
                              border: const OutlineInputBorder(),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultTextFormField(
                              label: 'Task Date',
                              controller: dateController,
                              type: TextInputType.none,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2023-04-01'),
                                ).then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value!).toString();
                                });
                              },
                              validator: (value) {
                                if(value.isEmpty) {
                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              prefixIcon: const Icon(Icons.calendar_month_outlined),
                              border: const OutlineInputBorder(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              fixedColor: color,
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived'
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

