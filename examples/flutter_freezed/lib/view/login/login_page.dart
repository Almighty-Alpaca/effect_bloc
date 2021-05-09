import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_effect_bloc/flutter_effect_bloc.dart';
import 'package:flutter_freezed/view/home/home_page.dart';

import 'login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EffectBlocConsumer<LoginBloc, LoginState, LoginEffect>(
        effectListener: (context, effect) {
      effect.when(
        errorIO: (code) => _showIoError(context),
        errorInvalidCredentials: () => _showInvalidCredentialsError(context),
        loggedIn: () => _goToHomePage(context),
      );
    }, builder: (_, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Log In"),
              onPressed: () {},
            )
          ],
        ),
      );
    });
  }

  void _showIoError(BuildContext context) {}

  void _showInvalidCredentialsError(BuildContext context) {}

  void _goToHomePage(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomePage()));
  }
}
