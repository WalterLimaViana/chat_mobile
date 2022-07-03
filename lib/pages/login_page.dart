import 'package:chat_mobile/allConstants/all_constants.dart';
import 'package:chat_mobile/provider/auth_provider.dart';
import 'package:chat_mobile/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: 'Falha no login');
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: 'Login foi cancelado');
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: 'Login realizado com sucesso');
        break;
      default:
        break;
    }
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.dimen_30,
              vertical: Sizes.dimen_20,
            ),
            children: [
              vertical50,
              const Text(
                'Bem vindo ao Chat Mobile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Sizes.dimen_26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              vertical30,
              const Text(
                'Faça o login para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Sizes.dimen_22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              vertical50,
              Center(
                child: Image.asset('assets/img/back.png'),
              ),
              vertical50,
              GestureDetector(
                onTap: () async {
                  bool isSuccess = await authProvider.handleGoogleSignIn();
                  if (isSuccess) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
                child: Image.asset('assets/img/google_login.jpg'),
              ),
              Center(
                child: authProvider.status == Status.authenticating
                    ? const CircularProgressIndicator(
                        color: AppColors.lightGrey,
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
