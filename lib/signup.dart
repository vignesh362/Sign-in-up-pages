import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signin_main/otp_code.dart';
import 'user_model.dart';

class signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new otp()
      },
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


Future<UserModel> createUser(String name, String email) async{
  final String apiUrl = "https://backend-parkingapp.herokuapp.com/signup";


  final response = await http.post(apiUrl, headers: {"Content-Type": "application/json"}, body: jsonEncode({
    "name": name,
    "email": email
  }));

  if(response.statusCode == 200){

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
bool validate=false;
bool validate2=false;
  UserModel _user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,

          body:Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                child: Text(
                  'Signup',
                  style:
                  TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                child: Text(
                  '.',
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              )
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'EMAIL',
                      errorText: ( validate  ) ? 'Please enter a email' : null,
                      //&&emailController.text.contains(".com")&& emailController.text.contains("@")validate
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',


                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(height: 10.0),

                SizedBox(height: 10.0),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'USER NAME ',
                      errorText: validate2 ? 'Please enter a Username' : null,
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
                  color: Colors.greenAccent,
                  child: Text('Sign In'),
                  onPressed: () async{
                    setState(() {
                      (nameController.text.isEmpty )? validate2 = true : validate = false;
                      ( emailController.text.isEmpty )? validate = true : validate = false;


                    });
                    if(validate==false && validate2==false) {
                      final String name = nameController.text;
                      final String email = emailController.text;

                      final UserModel user = await createUser(name, email);

                      setState(() {
                        _user = user;
                      });
                      //print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                      if (_user != null) {
                        setid();
                        getsharedpref();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => otp()),
                        );
                      }
                      if (user == null) {
                        print(user.message);
                      }
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
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child:

                      Center(
                        child: Text('Go Back',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat')),
                      ),


                    ),
                  ),
                ),
              ],
            )),

      ])
      , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  setid()async{
    print("#############################dddddddddddddddddddddddddd!!!!!!!!!!!!!!!!");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", _user.userId);

  }
  getsharedpref() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String id =preferences.getString("id") ;
    print(id);
  }
showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
     // Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Invalid Details"),
    content: Text("Enter your details properly."),
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
