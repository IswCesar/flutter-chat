import 'package:chat/global/colors.dart';
import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String title;
  final String subtitle;

  const Labels(
      {Key key,
      @required this.route,
      @required this.title,
      @required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final colors = ColorApp();

    return Container(
      margin: EdgeInsets.only(top:5.0),
      child: Column(
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(
              color: colors.labelAccountColor,
              fontSize: 20.0,
              fontFamily: "Geometric-212-BkCn-BT",
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          GestureDetector(
            child: Text(
              this.subtitle,
              style: TextStyle(
                color: colors.title,
                fontSize: 28.0,
                fontFamily: "Geometric-415-Black-BT",
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, this.route);
            },
          ),
        ],
      ),
    );
  }
}
