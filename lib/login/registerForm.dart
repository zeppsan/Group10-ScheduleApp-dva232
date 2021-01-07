import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

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
  bool _passwordVisible;
  bool _error400;
  bool _error201;

  //Error messages
  String _emailEmpty = "Please enter an email";
  String _emailNotValid = "Please enter an valid email";

  String _nameEmpty = "Please enter your name";
  String _nameTooShort = "Name need to be at least 2 characters";

  String _passwordEmpty = "Please enter a password";
  String _passwordTooShort = "Password too short. Minimum 6 characters";
  String _passwordNotMatch = "Passwords do not match";

  @override
  void initState() {
    super.initState();
    _error400 = false;
    _error201 = false;
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //Email input
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
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
          Visibility(
            visible: _error400,
            child: Text("Email taken", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.0)),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            keyboardType: TextInputType.text,
            validator: (nameValue) {
              if (nameValue.isEmpty) {
                return _nameEmpty;
              }
              else if (nameValue.length < 2){
                return _nameTooShort;
              }
              name = nameValue;
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
              hintText: "Enter password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              suffixIcon: IconButton(
                color: Colors.white,
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
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter password again",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              suffixIcon: IconButton(
                color: Colors.white,
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
            validator: (passwordConfirmationValue) {
              if (passwordConfirmationValue.isEmpty) {
                return _passwordEmpty;
              } else if (passwordConfirmationValue.length < 6) {
                return _passwordTooShort;
              } else if (passwordConfirmationValue != password) {
                return _passwordNotMatch;
              }
              passwordConfirmation = passwordConfirmationValue;
              return null;
            },
          ),
          Visibility(
            visible: _error201,
            child: Text("Registration complete", style: TextStyle(color: Colors.green, fontSize: 15.0),),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
            ),
            child: Text("Register", textAlign: TextAlign.center,),
            onPressed: () {
              // Validate returns true if the form is valid, or false
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a Snackbar.

                if (password == passwordConfirmation) {
                  //Register func to add data to backend
                  postRequest(
                      name: name,
                      email: email,
                      password: password,
                      passwordConfirmation: passwordConfirmation);
                }
              }
            },
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  void postRequest(
      {var name, var email, var password, var passwordConfirmation}) async {
    var url = 'https://qvarnstrom.tech/api/auth/register';

    Map data = {
      'email': '$email',
      'name': '$name',
      'password': '$password',
      'password_confirmation': '$passwordConfirmation'
    };

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 400) {
      print("Status 400: Email taken");
      //TODO: Error message to user
      setState(() {
        _error400 = true;
      });
    } else if (response.statusCode == 201) {
      print("Status 201: Registration complete");
      setState(() {
        _error201 = true;
        Navigator.pushReplacementNamed(context, "/");
      });
    }
  }
}
