import 'package:chat/global/colors.dart';
import 'package:flutter/material.dart';

class EnterButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const EnterButton({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = ColorApp();
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: colors.buttonBG,
      shape: StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 55.0,
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(
              color: colors.loginBG,
              fontSize: 26.0,
              fontFamily: "Geometric-415-Black-BT"
            ),
          ),
        ),
      ),
    );
  }
}
