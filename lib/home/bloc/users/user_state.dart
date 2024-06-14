// ignore_for_file: overridden_fields

class UserState {
  final List<User> users;

  UserState({this.users = const []});
}

class UsersLoaded extends UserState {
  // ignore: annotate_overrides
  final List<User> users;

  UsersLoaded(this.users);
}

class UsersLoading extends UserState {}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Construct a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
