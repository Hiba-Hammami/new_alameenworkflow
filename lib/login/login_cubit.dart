import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';
import '../models/urlweb.dart';
import '../models/password.dart';
import '../models/email.dart';
import '../models/user.dart';

class LoginCubit extends Cubit<User> {
  LoginCubit() : super(const User());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password, state.urlweb]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.email, state.urlweb]),
    ));
  }

  void urlChanged(String value) {
    final urlweb = UrlWeb.dirty(value);
    emit(state.copyWith(
      urlweb: urlweb,
      status: Formz.validate([urlweb, state.email, state.password]),
    ));
  }

  Future<void> logInWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, exceptionError: e.toString()));
    }
  }
}
