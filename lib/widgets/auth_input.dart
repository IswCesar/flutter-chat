import 'package:chat/global/colors.dart';
import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool isPassword;

  const AuthInput(
      {Key key,
      @required this.icon,
      @required this.placeholder,
      @required this.textEditingController,
      this.textInputType = TextInputType.text,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final colors = ColorApp();

    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.only(
        top: 5.0,
        left: 5.0,
        bottom: 5.0,
        right: 20.0,
      ),
      decoration: BoxDecoration(
        color: colors.inputBG,
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
          prefixIcon: new IconTheme(
              data: new IconThemeData(
                  color: colors.inputColor), 
              child: new Icon(this.icon),
          ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.placeholder,
          hintStyle: TextStyle(
            fontFamily: "Geometric-212-BkCn-BT",
          color: colors.inputColor,
          fontSize: 20.0
          )
        ),
        style: TextStyle(
          fontFamily: "Geometric-212-BkCn-BT",
          color: colors.inputColor,
          fontSize: 20.0
        ),
      ),
    );
  }
}
