import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool isPassword;

  const CustomInput(
      {Key key,
      @required this.icon,
      @required this.placeholder,
      @required this.textEditingController,
      this.textInputType = TextInputType.text,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.only(
        top: 5.0,
        left: 5.0,
        bottom: 5.0,
        right: 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: this.textEditingController,
        autocorrect: false,
        keyboardType: this.textInputType,
        obscureText: this.isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(this.icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.placeholder,
        ),
      ),
    );
  }
}
