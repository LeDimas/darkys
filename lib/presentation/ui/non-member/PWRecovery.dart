import 'package:darky_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PWRecoveryPage extends StatefulWidget {
  @override
  _PWRecoveryPageState createState() => _PWRecoveryPageState();
}

class _PWRecoveryPageState extends State<PWRecoveryPage> {
  final TextEditingController emailController = TextEditingController();

  final snackBar = SnackBar(
    content:
        Text('Password recovery instructions were sent to your email adress '),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6DC0C4),
          title: Text("Password recovery"),
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: SizedBox(
                        height: 30.0,
                      ),
                    ),
                    // HERE WILL GO DARKY'S LOGO
                    _buildMyDarkysLogo(),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Ja tu esi aizmirsis savu paroli,\n ievadi savu e-pastu un mēs tev to nosūtīsim uz e-pastu kaut ko ",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _buildEmailTF(),
                    SizedBox(
                      height: 30.0,
                    ),

                    _buildSendBtn(),
                  ],
                ),
              ),
            ),
          )
        ]));
  }

  Widget _buildEmailTF() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "E-mail",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
            alignment: Alignment.centerLeft,
            height: 64.0,
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF6DC0C4),
                ),
                hintText: "Ievadiet savu e-pastu",
              ),
            ),
          ),
        ]);
  }

  Widget _buildSendBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: Builder(
          builder: (ctx) => RaisedButton(
            elevation: 0,
            onPressed: () {
              context
                  .read(authenticationServiceProvider)
                  .resetPassword(emailController.text);

              Scaffold.of(ctx).showSnackBar(snackBar);
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pop(context);
              });

              print("Login Button Pressed");
            },
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Color(0xFF6DC0C4),
            child: Text(
              "Sūtīt",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                //fontFamily: Montserrat
              ),
            ),
            textColor: Colors.red,
          ),
        ));
  }
}

Widget _buildMyDarkysLogo() {
  return Container(
      child: new Image.asset("lib/assets/2020_darky_app_flutter_logo.png"),
      padding: EdgeInsets.symmetric(
        horizontal: 40.0,
      ));
}
