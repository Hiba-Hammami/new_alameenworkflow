import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:new_alameenhrworkflow/models/shared_pref.dart';
import 'package:new_alameenhrworkflow/models/user_data.dart';
import '../common/auth.text.field.dart';
import '../common/push_notification_service.dart';
import '../home/WebViewContainer.dart';
import '../models/user.dart';
import 'login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginForm> {
  final SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, User>(
        listener: (context, state) async {
          if (state.status.isSubmissionFailure) {
            print('submission failure');
          } else if (state.status.isSubmissionSuccess) {
            print(state.email);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Processing Data'),
                duration: Duration(milliseconds: 500)));
            UserData model = UserData();
            model.email = state.email.value;
            model.password = state.password.value;
            model.url = state.urlweb.value;
            bool isOk = await signIn(model);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(isOk ? "Saved!" : "Invalid user data"),
                duration: const Duration(milliseconds: 10000)));
          }
        },
        builder: (context, state) => Scaffold(
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/Workflow.png"),
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                            child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Alameen workflow",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, top: 10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Login",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, top: 10),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(child: _EmailInputField()),
                                    ])),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: _PasswordInputField(),
                                      )
                                    ])),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(child: _UrlInputField())
                                    ])),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      _LoginButton(),
                                    ])),
                          ],
                        ))),
                  ),
                  state.status.isSubmissionInProgress
                      ? const Positioned(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ));
  }

  Future<bool> signIn(UserData userdata) async {
    Dio dio = Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    String token = await PushNotificationService().getToken();

    var d = {
      'Email': userdata.email,
      'Password': userdata.password,
      'RememberMe': true,
      'MobileToken': token
    };

    Response response = await dio.post(
      userdata.url! + "/Account/LoginForMobile",
      data: FormData.fromMap(d),
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );

    if (response.data == false) {
      return false;
    }

    Map<String, String> _cookies = {};
    response.headers.forEach((String name, List<String> values) {
      if (name == 'set-cookie') {
        if (kDebugMode) {
          print(values);
        }
        // Get cookies for next request
        for (var rawCookie in values) {
          try {
            Cookie cookie = Cookie.fromSetCookieValue(rawCookie);
            _cookies[cookie.name] = cookie.value;
            if (kDebugMode) {
              print(cookie);
            }
          } catch (e) {
            final List<String> cookie = rawCookie.split(';')[0].split('=');
            _cookies[cookie[0]] = cookie[1];
          }
        }
      }
    });

    if (kDebugMode) {
      print(_cookies);
    }

    userdata.setcookie = _cookies;
    userdata.mobileToken = token;

    sharedPref.save("user", userdata);
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WebViewContainer(userdata.url, userdata.setcookie)));
    return true;
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, User>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthTextField(
            key: const Key('loginForm_emailInput_textField'),
            keyboardType: TextInputType.emailAddress,
            error: state.email.error?.name ?? "",
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            labelText: "EmailAddress",
            hintText: "me@abc.com",
            suffixIcon: const Icon(Icons.email));
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, User>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AuthTextField(
            padding: const EdgeInsets.symmetric(vertical: 5),
            isPasswordField: true,
            key: const Key('loginForm_passwordInput_textField'),
            keyboardType: TextInputType.text,
            error: state.password.error?.name ?? '',
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            labelText: "Password",
            hintText: "my password",
            suffixIcon: const Icon(Icons.lock_outline));
      },
    );
  }
}

class _UrlInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, User>(
      buildWhen: (previous, current) => previous.urlweb != current.urlweb,
      builder: (context, state) {
        return AuthTextField(
            key: const Key('loginForm_urlInputField_textField'),
            keyboardType: TextInputType.url,
            error: state.urlweb.error?.name ?? '',
            onChanged: (uweb) => context.read<LoginCubit>().urlChanged(uweb),
            labelText: "Url",
            hintText: "Url",
            suffixIcon: const Icon(Icons.link));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, User>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SizedBox(
            width: 200, // <-- match_parent
            height: 50,
            child: ElevatedButton.icon(
              label: Text(
                'Login',
                style: Theme.of(context).textTheme.button?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 50, 124, 106),
              ),
              onPressed: state.status.isValidated
                  ? () => context.read<LoginCubit>().logInWithCredentials()
                  : null,
              icon: const Icon(Icons.login),
            ));
      },
    );
  }
}
