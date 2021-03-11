import 'package:chat/global/colors.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final colors = ColorApp();

    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 80.0),
        width: 300.0,
        child: Column(
          children: <Widget>[
            Image(
              width: 170.0,
              image: AssetImage('assets/logo.png'),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              this.title,
              style: TextStyle(
                color: colors.title,
                fontSize: 44.0,
                fontFamily: "Geometric-415-Black-BT"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
