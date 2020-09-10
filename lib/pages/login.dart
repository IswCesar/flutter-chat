import 'package:chat/services/socket.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat/helpers/show_alert.dart';

import 'package:chat/services/auth.dart';
import 'package:chat/widgets/blue_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  title: 'Login',
                ),
                _Form(),
                Labels(
                  route: 'register',
                  title: '¿No tienes cuenta?',
                  subtitle: 'Crea una ahora!',
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
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
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.email,
            placeholder: "Email",
            textInputType: TextInputType.emailAddress,
            textEditingController: emailController,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: "Password",
            textEditingController: passwordController,
            isPassword: true,
          ),
          BlueButton(
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
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(
                          context, 'Login error', 'Check tour credentials');
                    }
                  },
          ),
        ],
      ),
    );
  }
}
