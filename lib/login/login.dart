import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'XonorK';

      return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: LoginForm(),
      );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  _LoginForm createState() {
    return _LoginForm();
  }
}

class _LoginForm extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  //Send to backend
                  postRequest(email: email,password: password);
                }
              },
              child: Text('Login'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Register())
                );
              },
              child: Text("Register"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, "/map");
              },
              child: Text("Continue without register/login"),
            ),
          ),
        ],
      ),
    );
  }

  void postRequest ({var email, var password}) async {
    print(email);
    print(password);
    var url ='https://qvarnstrom.tech/api/auth/login';

    Map data = {
      'email': '$email',
      'password': '$password',
    };

    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("${response.statusCode}");
    print("${response.body}");

    Map responseData = jsonDecode(response.body);
    print(responseData["access_token"]);

    if(responseData["access_token"] != null){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(responseData["access_token"]));
      Navigator.pushReplacementNamed(context, '/thisweek');
    }
  }
}