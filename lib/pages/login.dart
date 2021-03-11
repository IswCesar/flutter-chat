import 'package:chat/services/socket.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat/helpers/show_alert.dart';

import 'package:chat/services/auth.dart';
import 'package:chat/widgets/enter_button.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:chat/global/colors.dart';
import 'package:chat/widgets/auth_input.dart';

class LoginPage extends StatelessWidget {
  final colors = new ColorApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.loginBG,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  title: 'CHIT-CHAT',
                ),
                _Form(),
                Labels(
                  route: 'register',
                  title: "You don't have an acount?",
                  subtitle: 'Contact us!',
                ),
                // Text(
                //   'Términos y condiciones de uso',
                //   style: TextStyle(fontWeight: FontWeight.w200),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final socket = Provider.of<Socket>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          AuthInput(
            icon: Icons.email,
            placeholder: "Email",
            textInputType: TextInputType.emailAddress,
            textEditingController: emailController,
          ),
          AuthInput(
            icon: Icons.lock,
            placeholder: "Password",
            textEditingController: passwordController,
            isPassword: true,
          ),
          EnterButton(
              text: 'Enter',
              onPressed: auth.authenticating
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final loginOk = await auth.login(
                          emailController.text.trim(),
                          passwordController.text.trim());
                      if (loginOk) {
                        socket.connect();
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        showAlert(
                            context, 'Login error', 'Check tour credentials');
                      }
                    }),
        ],
      ),
    );
  }
}
