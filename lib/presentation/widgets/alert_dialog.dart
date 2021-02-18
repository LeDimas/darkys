import 'package:flutter/material.dart';

class YesNoAlert extends StatelessWidget {
  const YesNoAlert({
    Key key,
    this.title,
    this.content,
    this.onYes,
    this.onNo,
  }) : super(key: key);
  final String title;
  final String content;
  final Function onYes;
  final Function onNo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton(onPressed: onYes, child: Text("Yes")),
        FlatButton(onPressed: onNo, child: Text("No"))
      ],
      elevation: 24,
    );
  }
}
