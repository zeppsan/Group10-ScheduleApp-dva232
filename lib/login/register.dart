import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'XonorK';

      return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: RegisterForm(),
      );
  }
}

// Create a Form widget.
class RegisterForm extends StatefulWidget {
  @override
  _RegisterForm createState() {
    return _RegisterForm();
  }
}

class _RegisterForm extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var name;
  var email;
  var password;
  var passwordConfirmation;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Email input
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Enter email",
            ),
            validator: (emailValue) {
              if (emailValue.isEmpty) {
                return 'Please enter some text';
              }
              email = emailValue;
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Enter name",
            ),
            keyboardType: TextInputType.text,
            validator: (nameValue) {
              if (nameValue.isEmpty) {
                return 'Please enter some text';
              }
              name = nameValue;
              return null;
            },
          ),
          //Password
          TextFormField(
            decoration: InputDecoration(
              labelText: "Enter password",
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            validator: (passwordValue) {
              if (passwordValue.isEmpty) {
                return 'Please enter some text';
              }
              password = passwordValue;
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Enter password again",
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            validator: (passwordConfirmationValue) {
              if (passwordConfirmationValue.isEmpty) {
                return 'Please enter some text';
              }
              passwordConfirmation = passwordConfirmationValue;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.

                  if(password == passwordConfirmation) {
                    //Register func to add data to backend
                    postRequest(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation);
                  }
                }

              },
              child: Text('Register'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Back to login"),
            ),
          ),
        ],
      ),
    );
  }

  void postRequest ({var name, var email, var password, var passwordConfirmation}) async {
    print(name);
    print(email);
    print(password);
    print(passwordConfirmation);
    var url ='https://qvarnstrom.tech/api/auth/register';

    Map data = {
      'email': '$email',
      'name': '$name',
      'password': '$password',
      'password_confirmation': '$passwordConfirmation'
    };

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    if(response.statusCode == 400){
      //TODO: Error message to user
      print("Email taken");
    }
    else if(response.statusCode == 201){
      //TODO: Message to user
      print("Registration complete");
    }

    print("${response.statusCode}");
    print("${response.body}");
  }
}