import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({Key key,
    @required this.message,}) :super(key: key);

  @override
  /*Widget build(BuildContext context) {
    print ('msg display');
    print (message);
    print(MediaQuery.of(context).size.height/2);
    return Container (
      child: Center(
          child: Text(
            message,
            style:TextStyle(fontSize: 25),
            textAlign:TextAlign.center,
          ),
      ),
    );//Container
  }
}*/
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