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
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            child: Text(
              this.subtitle,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
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
