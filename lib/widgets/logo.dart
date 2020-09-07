import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 50.0),
        width: 170.0,
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/tag-logo.png'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              this.title,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
