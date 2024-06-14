import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/main.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TasksLoading()) {
    on<LoadTasks>((event, emit) async {
      final tasks = await dbHelper.getTasks();
      emit(TasksLoaded(tasks));
    });

    on<AddTask>((event, emit) {
      final updatedTasks = List<Task>.from(state.tasks)
        ..add(Task(
          id: event.id,
          title: event.title,
          description: event.description,
          assignedUser: event.assignedUser,
        ));
      emit(TasksLoaded(updatedTasks));
    });
  }
}
