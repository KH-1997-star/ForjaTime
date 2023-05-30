part of 'login_cubit.dart';

enum LoginStatus { initial, writing, submitting, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final String? emailErrorMessage;
  final String? passwordErrorMessage;
  final String? otherError;
  final LoginStatus status;

  const LoginState({
    required this.email,
    required this.password,
    required this.emailErrorMessage,
    required this.passwordErrorMessage,
    required this.otherError,
    required this.status,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      emailErrorMessage: null,
      passwordErrorMessage: null,
      otherError: null,
      status: LoginStatus.initial,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    String? emailErrorMessage,
    String? passwordErrorMessage,
    String? otherError,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailErrorMessage: emailErrorMessage ?? this.emailErrorMessage,
      passwordErrorMessage: passwordErrorMessage ?? this.passwordErrorMessage,
      otherError: otherError ?? this.otherError,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailErrorMessage,
        passwordErrorMessage,
        otherError,
        status
      ];
}
