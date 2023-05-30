import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: LoginStatus.writing,
      emailErrorMessage: value.isEmpty ? 'entrer email' : '',
    ));
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: LoginStatus.writing,
        passwordErrorMessage: value.isEmpty ? 'entrer mot de passe' : '',
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submitting) return;

    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      if (e is LogInWithEmailAndPasswordFailure) {
        if (e.email ?? false) {
          emit(state.copyWith(
              status: LoginStatus.error, emailErrorMessage: e.message));
        } else if (e.password ?? false) {
          emit(state.copyWith(
              status: LoginStatus.error, passwordErrorMessage: e.message));
        } else {
          emit(
              state.copyWith(status: LoginStatus.error, otherError: e.message));
        }
      }
    }
  }

  Future<void> logInWithGoogleCredentials() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.signInWithGoogle();

      emit(state.copyWith(status: LoginStatus.success));
    } catch (_) {
      if (_ is LogInWithGoogleFailure) {
        emit(state.copyWith(status: LoginStatus.error, otherError: _.message));
      }
    }
  }
}
