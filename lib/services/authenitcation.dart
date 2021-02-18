import 'package:darky_app/models/member.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'database_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  void whoAmI() {
    print(_firebaseAuth.currentUser.email);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  String get currentUserEmail => FirebaseAuth.instance.currentUser.email;

  Future signIn({@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      if (userCredential != null) {
        print("Logging in");
        DatabaseService.checkUserLogin(user);
        return userFromFirebaseUser(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found")
        return "No user found with provided email.";
      else if (e.code == "wrong-password")
        return "Incorrect password for this user";
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //map heavy FirebaseUser on light member class
  Member userFromFirebaseUser(User user) =>
      user != null ? Member(email: user.email) : null;

  //getter section

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<Member> get member => _firebaseAuth
      .authStateChanges()
      .map((User user) => userFromFirebaseUser(user));
}
