import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleService {
  Future<String> getRole() async {
    User user = FirebaseAuth.instance.currentUser;
    var userData = await FirebaseFirestore.instance
        .collection('members')
        .doc(user.email)
        .get();

    return userData.data()['role'];
  }
}
