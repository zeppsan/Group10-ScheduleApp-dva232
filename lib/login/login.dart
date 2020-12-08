import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';
import 'loginCheck.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'XonorK';
    checkLogin(context);
      return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: LoginForm(),
      );
  }
  void checkLogin (context) async{
    SharedPreferences key = await SharedPreferences.getInstance();
    key.getString('token');
    print(key.getString('token'));
    if(key.getString('token') != null)
    {
      Navigator.pushReplacementNamed(context, '/thisweek');
    }
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
    return ListView(
      children: [
        Form(
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
                else if(isEmail(emailValue.toLowerCase()) == false) {
                  return 'Please enter an valid email';
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
                else if(passwordValue.length < 6){
                  return 'Too short password. Min 6 characters';
                }
                password = passwordValue;
                return null;
              },
            ),
            //LoginButton
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    postRequest(email: email,password: password);
                  }
                },
                child: Text('Login'),
              ),
            ),
            //RegisterButton
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
            //Continue without register/login
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
      ),
    ]
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

    if(response.statusCode == 200) {
      print("${response.statusCode}");
      print("${response.body}");

      Map responseData = jsonDecode(response.body);
      print(responseData['access_token']);

      if (responseData['access_token'] != null) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', responseData['access_token']);
        Navigator.pushReplacementNamed(context, '/thisweek');
      }
    }
    else if(response.statusCode == 401){
      //TODO: Error message to user. Something wrong with the error code 401
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Unauthorized"),
          duration: const Duration(seconds: 3),
        ));
      });
    }
    else if(response.statusCode == 422){
      //TODO: Error message to user
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Wrong email or password"),
          duration: const Duration(seconds: 3),
        ));
      });
    }
  }
}