import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:training_app/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:training_app/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:training_app/modules/todo_app/new_tasks/new_tasks_screen.dart';
import 'package:training_app/shared/cubit/states.dart';
import 'package:training_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  ThemeMode appMode = ThemeMode.light;
  bool isDark = false;
  void changeAppMode ({bool? fromShared}){

    if(fromShared!=null) {
      isDark = fromShared;
    } else {
      isDark = !isDark;
    }
    CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
      emit(AppChangeModeState());
    });

  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  late Database database;
  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)
      {
        // 1. id integer
        // 2. title string
        // 3. date string
        // 4. time string
        // 5. status string

        print('Databse created');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then<void>((value) async {
          print('table created');
        }).catchError((error){
          print('Error when created Table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('Datebase opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }
  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async
    {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
      ).then<void>((value) async {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error){
        print('Error when inserting new Record ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
     value.forEach((element) {
       if(element['status'] == 'new'){
         newTasks.add(element);
       } else if(element['status'] == 'done'){
         doneTasks.add(element);
       } else {
         archivedTasks.add(element);
       }
     });
     emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });

  }

  void deleteDatabase({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });

  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}