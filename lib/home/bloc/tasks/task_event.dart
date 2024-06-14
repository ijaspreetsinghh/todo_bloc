import 'package:todo_bloc/home/bloc/users/user_state.dart';

abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final int id;
  final String title;
  final String description;
  final User assignedUser;

  AddTask(
      {required this.title,
      required this.id,
      required this.description,
      required this.assignedUser});
}

class LoadTasks extends TaskEvent {}
