import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signin_main/reotpverify.dart';




class loginPhotp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
Future<Reotpverify> Photpverify(String otp) async {
  final String apiUrl = "https://backend-parkingapp.herokuapp.com/ContactOtpcheck";

  SharedPreferences preferences=await SharedPreferences.getInstance();
  final response = await http.post(
      apiUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
    "userId": preferences.getString("id"),
    "otp": otp
  }));
  print(response.statusCode);
  if (response.statusCode >300) {

    final String responseString = response.body;

    return reotpverifyFromJson(responseString);
  }
  else  {
    print('********************************************************************');
    print(response.statusCode);
    return null;
  }
}
Future<Reotpverify> resendotpverify() async {
  print('********************************111111111111111111111resendotp11111111111111111111111111111111***********************************');

  final String apiUrl = "https://backend-parkingapp.herokuapp.com/ContactResendotp";

  SharedPreferences preferences=await SharedPreferences.getInstance();
  final response = await http.post(
      apiUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
    "userId": preferences.getString("id"),

  }));
  print(response.statusCode);
  if (response.statusCode < 300) {
    print('*********************************222222222222222222222222222222222222222222222222222222222***********************************');
    final String responseString = response.body;
    return  reotpverifyFromJson(responseString) ;
  }
  else if (response.statusCode == 422) {
    print('********************************************************************');
    print(response.statusCode);
    return null;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  TextEditingController otpController = TextEditingController();
  Future<void> initState()   {
    super.initState();
    resendotpverify();
  }
  Reotpverify _user;
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
                    child: Text('Verify your                    contact',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),


                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '*Enter otp sent to your phone',
                  style: TextStyle(fontFamily: 'Montserrat',
                    color: Colors.greenAccent,),
                ),
                SizedBox(width: 5.0),

              ],
            ),
            SizedBox(height: 100.0),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(

                          labelText: 'otp',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent))),

                    ),

                    SizedBox(height: 50.0),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.greenAccent,
                      child: Text('Verify'),
                      onPressed: () async{

                        final String otp = otpController.text;

                        final  Reotpverify user = await Photpverify(otp);
                        print(user.message);

                        setState(() {
                          _user = user;
                        });

                        print(user.message);
                      },
                    ),

                    SizedBox(height: 20.0),

                    SizedBox(height: 20.0),

                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Didnt recieve otp?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () async {
                    final  Reotpverify user1 = await resendotpverify();
                    print(user1.message);
                  },
                  child: Text(
                    'resend otp',
                    style: TextStyle(
                        color: Colors.greenAccent,
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
}
