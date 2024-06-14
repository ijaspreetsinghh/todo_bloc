import 'package:todo_bloc/home/bloc/users/user_state.dart';

class TaskState {
  final List<Task> tasks;

  TaskState({this.tasks = const []});
}

class Task {
  final int id;
  final String title;
  final String description;
  final User assignedUser;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedUser,
  });

  factory Task.fromMap(Map<String, dynamic> map, User user) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      assignedUser: user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'user_id': assignedUser.id,
    };
  }
}

class TasksLoading extends TaskState {}

class TasksLoaded extends TaskState {
  TasksLoaded(List<Task> tasks) : super(tasks: tasks);
}
