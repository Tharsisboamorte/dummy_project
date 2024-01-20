part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class CreatingUser extends AuthState {
  const CreatingUser();
}

class GettingUsers extends AuthState{
  const GettingUsers();
}

class UserCreated extends AuthState{
  const UserCreated();
}

class UsersLoaded extends AuthState{
  const UsersLoaded(this.users);

  final List<User> users;

  @override
  List<Object> get props => users.map((user) => user.id).toList();
}

class AuthenticationError extends AuthState{
  const AuthenticationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}