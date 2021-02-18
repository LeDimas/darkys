import 'package:darky_app/services/database_service.dart';
// import 'package:darky_app/services/firebase_admin_apiManager.dart';
import 'package:darky_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

//CONSIDER MAKING STATEFULL TO INFORM ABOUT SUCCESFUL REGISTRATION
class RegisterMemberPage extends StatefulWidget {
  @override
  _RegisterMemberPageState createState() => _RegisterMemberPageState();
}

class _RegisterMemberPageState extends State<RegisterMemberPage> {
  bool loading = false;
  bool isBboy;
  bool isHipHoper;
  bool isMultiGroup;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameController = TextEditingController();

  @override
  void initState() {
    isBboy = false;
    isHipHoper = false;
    isMultiGroup = false;
    super.initState();
  }

  String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6DC0C4),
        title: Text(
          "Member registration",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Add a player",
                style: GoogleFonts.abel(fontSize: 35),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //text field for name
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value.isEmpty && value.length < 4) {
                        return "please enter name that contains at least 4 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepPurple, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlue, width: 3))),
                  ),
                  //Boxview for some air between inputs
                  SizedBox(
                    height: 40,
                  ),
                  //Text field for password
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty && value.length < 6) {
                        return "please enter name that contains at least 4 characters";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepPurple, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlue, width: 3))),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty && value.length < 4) {
                        return "please enter name that contains at least 4 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Name",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepPurple, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlue, width: 3))),
                  ),
                  //Boxview for some air between inputs
                  SizedBox(
                    height: 40,
                  ),
                  Text("Select section"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: isBboy,
                          onChanged: (val) {
                            setState(() {
                              isBboy = val;
                            });
                          }),
                      Text("Breaking"),
                      Checkbox(
                          value: isHipHoper,
                          onChanged: (val) {
                            setState(() {
                              isHipHoper = val;
                            });
                          }),
                      Text("Hip-Hop"),
                      Checkbox(
                          value: isMultiGroup,
                          onChanged: (val) {
                            setState(() {
                              isMultiGroup = val;
                            });
                          }),
                      Text("Multi-group"),
                    ],
                  ),

                  RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          DatabaseService(email: _emailController.text)
                              .setUserDataOnFirebase(
                                  _emailController.text,
                                  _nameController.text,
                                  isBboy,
                                  isHipHoper,
                                  isMultiGroup);
                          DatabaseService.addBill(
                              DateTime.now(), _emailController.text);

                          context
                              .read(firebaseAdminApiProvider)
                              .createFirebaseAuthUser(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  username: _nameController.text);
                        }
                        _emailController.clear();
                        _passwordController.clear();
                        _nameController.clear();
                        isBboy = false;
                        isHipHoper = false;
                        isMultiGroup = false;
                        setState(() {});

                        print("New account is created");
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text('Add a member ',
                              style: TextStyle(fontSize: 15))))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
