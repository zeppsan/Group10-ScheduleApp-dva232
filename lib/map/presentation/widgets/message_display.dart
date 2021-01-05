import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Widget to present errors and messages

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({Key key,
    @required this.message,}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: [
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}