part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, writing, error }

class SignupState extends Equatable {
  final String email;
  final String password;
  final String? emailErrorMessage;
  final String? passwordErrorMessage;
  final String? otherError;
  final SignupStatus status;

  const SignupState({
    required this.email,
    required this.password,
    required this.emailErrorMessage,
    required this.passwordErrorMessage,
    required this.otherError,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: '',
      password: '',
      emailErrorMessage: null,
      passwordErrorMessage: null,
      otherError: null,
      status: SignupStatus.initial,
    );
  }

  SignupState copyWith({
    String? email,
    String? password,
    String? emailErrorMessage,
    String? passwordErrorMessage,
    String? otherError,
    SignupStatus? status,
  }) {
    return SignupState(
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
