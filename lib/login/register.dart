import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

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
  bool _passwordVisible;

  @override
  void initState() {
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
                return 'Please enter some text';
              } else if (isEmail(emailValue.toLowerCase()) == false) {
                return 'Please enter an valid email';
              }
              email = emailValue;
              return null;
            },
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
                return 'Please enter some text';
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
                return 'Please enter some text';
              } else if (passwordValue.length < 6) {
                return 'Too short password. Min 6 characters';
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
                return 'Please enter some text';
              } else if (passwordConfirmationValue.length < 6) {
                return 'Too short password. Min 6 characters';
              } else if (passwordConfirmationValue != password) {
                return 'Passwords do not match';
              }
              passwordConfirmation = passwordConfirmationValue;
              return null;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
              child: Text(
                "Register",
                textAlign: TextAlign.center,
              ),
            ),
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
    print(name);
    print(email);
    print(password);
    print(passwordConfirmation);
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
      //TODO: Error message to user
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Email taken"),
          duration: const Duration(seconds: 3),
        ));
      });
      print("Email taken");
    } else if (response.statusCode == 201) {
      //TODO: Message to user. Autofill the loginboxes?
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Registration complete"),
          duration: const Duration(seconds: 3),
        ));
        Navigator.pushReplacementNamed(context, "/");
      });
      print("Registration complete");
    }

    print("${response.statusCode}");
    print("${response.body}");
  }
}
