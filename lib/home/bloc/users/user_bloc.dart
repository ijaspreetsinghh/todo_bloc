import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/home/bloc/users/user_state.dart';
import 'package:todo_bloc/main.dart';

// Events
abstract class UserEvent {}

class AddUser extends UserEvent {
  final String name;
  final String email;
  final int id;
  AddUser({required this.name, required this.email, required this.id});
}

class LoadUsers extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {
  final List<User> _users = [];

  UserBloc() : super(UsersLoading()) {
    on<LoadUsers>((event, emit) async {
      final users = await dbHelper.getUsers();
      _users.addAll(users);
      emit(UsersLoaded(List.from(_users)));
    });

    on<AddUser>((event, emit) {
      final newUser = User(id: event.id, name: event.name, email: event.email);
      _users.add(newUser);
      emit(UsersLoaded(List.from(_users)));
    });
  }
}
