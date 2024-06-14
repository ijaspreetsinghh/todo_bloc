abstract class UserEvent {}

class AddUser extends UserEvent {
  final String name;
  final String email;
  final int id;
  AddUser({required this.name, required this.email, required this.id});
}

class LoadUsers extends UserEvent {}
