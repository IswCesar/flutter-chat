import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/widgets/blue_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';

import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/socket.dart';

import 'package:chat/services/auth.dart';

class RegisterPage extends StatelessWidget {
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
                  title: 'Register',
                ),
                _Form(),
                Labels(
                  route: 'login',
                  title: '¿Ya tienes cuenta?',
                  subtitle: 'Ingresa ahora!',
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
  final nameController = TextEditingController();

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
            icon: Icons.perm_identity,
            placeholder: "Name",
            textEditingController: nameController,
          ),
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
