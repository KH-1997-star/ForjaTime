import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: SignupStatus.writing,
      emailErrorMessage: value.isEmpty ? 'entrer email' : '',
    ));
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignupStatus.writing,
        passwordErrorMessage: value.isEmpty ? 'entrer mots de passe' : '',
      ),
    );
  }

  Future<void> signupFormSubmitted() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      await _authRepository.signup(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SignupStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
          status: SignupStatus.error,
          emailErrorMessage: e.email == true ? e.message : null,
          passwordErrorMessage: e.password == true ? e.message : null,
          otherError:
              e.password != true && e.email != true ? e.message : null));
    } catch (_) {}
  }
}
