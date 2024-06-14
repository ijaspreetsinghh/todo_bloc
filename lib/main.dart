import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/home/bloc/navigation/navigation_bloc.dart';
import 'package:todo_bloc/home/bloc/navigation/navigation_event.dart';
import 'package:todo_bloc/home/bloc/tasks/task_bloc.dart';
import 'package:todo_bloc/home/bloc/tasks/task_event.dart';
import 'package:todo_bloc/home/bloc/users/user_bloc.dart';
import 'package:todo_bloc/home/database/database.dart';
import 'package:todo_bloc/home/home.dart';

late DatabaseHelper dbHelper;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbHelper = DatabaseHelper.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => NavigationBloc()..add(TabTapped(index: 0))),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc()..add(LoadUsers()),
          ),
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc()..add(LoadTasks()),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}
