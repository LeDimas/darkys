import 'package:darky_app/presentation/ui/non-member/PWRecovery.dart';
import 'package:flutter/material.dart';
import 'package:darky_app/services/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Widget _buildEmailTF() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "E-pasts",
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

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Parole",
          style: TextStyle(
            color: Colors.white,
          ),
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
            controller: passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFF6DC0C4),
              ),
              hintText: "Ievadi paroli",
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PWRecoveryPage()));
          print("Forgot Password Button Pressed");
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          "Aizmirsi paroli?",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 0,
        onPressed: () {
          context.read(authenticationServiceProvider).signIn(
              email: emailController.text, password: passwordController.text);

          emailController.clear();
          passwordController.clear();
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Color(0xFF6DC0C4),
        child: Text(
          "Ielogoties",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            //fontFamily: Montserrat
          ),
        ),
      ),
    );
  }

  Widget _buildMyDarkysLogo() {
    return Container(
        child: new Image.asset("lib/assets/2020_darky_app_flutter_logo.png"),
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6DC0C4),
        title: Text("LOGIN"),
      ),
      body: Stack(
        children: [
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
                    Center(
                      child: _buildMyDarkysLogo(),
                    ),
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
                    _buildEmailTF(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordTF(),
                    _buildForgotPassword(),
                    _buildLoginBtn(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
