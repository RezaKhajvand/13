part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent(this.username, this.password);
  final String username;
  final String password;

  @override
  List<Object> get props => [];
}
