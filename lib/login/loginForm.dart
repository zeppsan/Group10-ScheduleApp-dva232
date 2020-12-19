import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  _LoginForm createState() {
    return _LoginForm();
  }
}

class _LoginForm extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool _passwordVisible;
  bool _rememberMe;

  //Error messages
  String _emailEmpty = "Please enter an email";
  String _emailNotValid = "Please enter an valid email";

  String _passwordEmpty = "Please enter a password";
  String _passwordTooShort = "Password too short. Minimum 6 characters";

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _rememberMe = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //Email input
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (emailValue) {
              if (emailValue.isEmpty) {
                return _emailEmpty;
              } else if (isEmail(emailValue.toLowerCase()) == false) {
                return _emailNotValid;
              }

              email = emailValue;
              return null;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          //Password
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              suffixIcon: IconButton(
                icon: Icon(
                  //If _passwordVisible is true show the visibility icon else visibility_off
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  //Redraw the page and switch the password visibility state
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
            keyboardType: TextInputType.text,
            obscureText: !_passwordVisible,
            validator: (passwordValue) {
              if (passwordValue.isEmpty) {
                return _passwordEmpty;
              } else if (passwordValue.length < 6) {
                return _passwordTooShort;
              }
              password = passwordValue;
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Remember Me"),
              Checkbox(
                value: _rememberMe,
                onChanged: (bool newValue){
                  setState(() {
                    _rememberMe = newValue;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
            ),
            child: Text("Login", textAlign: TextAlign.center),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                postRequest(email: email, password: password);
              }
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
            ),
            child: Text("Continue without register", textAlign: TextAlign.center,),
            onPressed: () {
                Navigator.pushReplacementNamed(context, "/thisweek");
              },
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  void postRequest({var email, var password}) async {
    print(email);
    print(password);
    var url = 'https://qvarnstrom.tech/api/auth/login';

    Map data = {
      'email': '$email',
      'password': '$password',
    };

    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      print("${response.statusCode}");
      print("${response.body}");

      Map responseData = jsonDecode(response.body);
      print(responseData['access_token']);

      if (responseData['access_token'] != null) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        //Set the recived token to localStorage
        await localStorage.setString('token', responseData['access_token']);
        //Bool to check in settings to switch between logout/login
        await localStorage.setBool('loggedIn', true);
        //Remove the stored schedule and course list,
        // to fill with the once from the database
        await localStorage.remove('rawSchedule');
        await localStorage.remove('course_list');

        //Store the email and password in local storage,
        //Will be used to contact the API in the background

        if(_rememberMe){
          localStorage.setString('email', email);
          localStorage.setString('password', password);
        }

        Navigator.pushReplacementNamed(context, '/thisweek');
      }
    } else if (response.statusCode == 401) {
      //TODO: Error message to user. Something wrong with the error code 401
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Unauthorized"),
          duration: const Duration(seconds: 3),
        ));
      });
    } else if (response.statusCode == 422) {
      //TODO: Error message to user
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Invalid email or password"),
          duration: const Duration(seconds: 3),
        ));
      });
    }
  }
}
