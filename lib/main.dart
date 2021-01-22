import 'dart:convert';
import 'package:signin_main/loginotp.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signin_main/loginphotp.dart';
import 'package:signin_main/phoneno.dart';
import 'package:signin_main/user_model.dart';
import 'signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new signup()
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

Future<UserModel> createUser(String email) async{
  final String apiUrl = "https://backend-parkingapp.herokuapp.com/login";


  final response = await http.post(apiUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
    "credential": email
  }));

  if(response.statusCode == 200) {
    final String responseString = response.body;

      return userModelFromJson(responseString);

  }
  else if(response.statusCode == 422){
    print('********************************************************************');
    print(response.statusCode);
    return null;
  }

}

class _MyHomePageState extends State<MyHomePage> {
  bool abc=false;
  @override
  TextEditingController emailController = TextEditingController();

  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Hello',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('There',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller:emailController,
                      decoration: InputDecoration(

                          labelText: 'EMAIL',
                          errorText:abc? 'Please enter a Username' : null,
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),

                    ),

                    SizedBox(height: 50.0),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Sign In'),
                      onPressed: (){
                        setState(() {
                          emailController.text.isEmpty ? abc = true : abc = false;
                        });
                        if(abc==false) {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirm email"),
                                content: Text(emailController.text),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text('OK'),
                                    onPressed: () async {
                                      final UserModel user = await createUser(
                                          emailController.text);
                                      try {
                                        print(user.message);
                                      } catch (e) {
                                        print(
                                            "erroe++++++++++++++++++++++++++++");
                                        showAlertDialog(context);
                                      }
                                      if (user.userId != null) {
                                        SharedPreferences preferences = await SharedPreferences
                                            .getInstance();
                                        preferences.setString(
                                            "id", user.userId);
                                      }
                                      print(
                                          "12121212121212121222222222222222222222111111111111111");
                                      //print(user.message);

                                      print(user.userId);
                                      if (user.message ==
                                          "Contact Number Not Verified") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  loginPhotp()),
                                        );
                                      }
                                      if (user.message ==
                                          "Otp Send to Your Mail") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => loginotp()),
                                        );
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                        else
                          {
                            showAlertDialog(context);
                          }
                      },
                    ),

                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child:
                              ImageIcon(AssetImage('images/google-logo.png')),
                            ),
                            SizedBox(width: 10.0),
                            Center(
                              child: Text('Log in with Google',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child:
                              ImageIcon(AssetImage('images/facebook-new.png')),
                            ),
                            SizedBox(width: 10.0),
                            Center(
                              child: Text('Log in with Facebook',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New to Parking ?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ));
  }
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Invalid Email"),
      content: Text("Enter an valid email."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
