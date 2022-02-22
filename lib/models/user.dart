import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:new_alameenhrworkflow/models/email.dart';
import 'package:new_alameenhrworkflow/models/password.dart';
import 'package:new_alameenhrworkflow/models/urlweb.dart';

class User extends Equatable {
  const User(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.status = FormzStatus.pure,
      this.urlweb = const UrlWeb.pure(),
      this.exceptionError = ""});

  final Email email;
  final Password password;
  final FormzStatus status;
  final UrlWeb urlweb;
  final String exceptionError;

  @override
  List<Object> get props => [email, password, status, urlweb, exceptionError];

  User copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    UrlWeb? urlweb,
    String? exceptionError = "",
  }) =>
      User(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        urlweb: urlweb ?? this.urlweb,
        exceptionError: exceptionError ?? this.exceptionError,
      );
}
