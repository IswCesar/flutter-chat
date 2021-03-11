import 'package:chat/global/colors.dart';
import 'package:chat/widgets/auth_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/widgets/enter_button.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';

import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/socket.dart';

import 'package:chat/services/auth.dart';

class RegisterPage extends StatelessWidget {

  final colors = new ColorApp();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.loginBG,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.99,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  title: 'CHIT-CHAT',
                ),
                _Form(),
                Labels(
                  route: 'login',
                  title: 'Do you have an acount?',
                  subtitle: 'Enter now!',
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
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    final socket = Provider.of<Socket>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          AuthInput(
            icon: Icons.perm_identity,
            placeholder: "Name",
            textEditingController: nameController,
          ),
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
            onPressed: auth.registering
                ? null
                : () async {
                    print('Blue button tapped');
                    print(emailController.text);
                    print(passwordController.text);
                    FocusScope.of(context).unfocus();
                    final registerOk = await auth.register(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim());
                    if (registerOk == true) {
                      socket.connect();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(context, 'Register error', registerOk);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
