import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:signin_main/phoneotp.dart';
import 'package:signin_main/reotpverify.dart';


class phone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,

      home: new MyHomePage(),
    );
  }
}
Future<Reotpverify> Photpverify(String pno) async {
  final String apiUrl = "https://backend-parkingapp.herokuapp.com/contactNumber";

  SharedPreferences preferences=await SharedPreferences.getInstance();
  final response = await http.post(
      apiUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
    "userId": preferences.getString("id"),
    "contactNumber": pno
  }));
  print(response.statusCode);
  if (response.statusCode ==200) {

    final String responseString = response.body;

    return reotpverifyFromJson(responseString);
  }
  else  {
    print('********************************************************************');
    print(response.statusCode);
    return null;
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  TextEditingController PnoController = TextEditingController();
  @override

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
                    child: Text('Verify',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('Phone no',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(350.0, 175.0, 0.0, 0.0),
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
                      controller: PnoController,
                      decoration: InputDecoration(
                          prefixIcon:Text("+91"),
                          labelText: 'Phone number',
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),

                    ),

                    SizedBox(height: 100.0),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Verify'),
                      onPressed: (){
                        final String pno = PnoController.text;
                        final String pnof="+91"+pno;
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("is the number correct ?"),
                              // Retrieve the text which the user has entered by
                              // using the TextEditingController.
                              content: Text(pnof),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('OK'),
                                  onPressed: () async {

                                    final Reotpverify user = await Photpverify(pnof);
                                    print(user.message);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Photp()),
                                    );
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 20.0),


                  ],
                )),
            SizedBox(height: 35.0),

          ],
        ));
  }
}
