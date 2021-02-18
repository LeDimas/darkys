import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  static void getHttp() async {
    var httpClient = http.Client();
    String url = 'http://10.0.2.2:5000/firebaseadmin/test';
    final reply = await httpClient.get('$url');
    if (reply.statusCode == 200) {
      print("URA");
    }
    var response = reply.body;
    print(response);
  }

  static Future notifySingleAddressantViaCloudMessaging(
      {@required String title,
      @required String message,
      @required String token}) async {
    String url = 'http://10.0.2.2:5000/notify_single';
    Map<String, dynamic> dataToPost = {
      'token': token,
      'message': message,
      'title': title
    };
    var jsonTokens = json.encode(dataToPost);
    var response = await http.post('$url',
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonTokens);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("succesfully multicasted notification");
    } else {
      print("something wrong with flask server");
    }
  }

  static Future deleteUserAccount({@required String email}) async {
    Map<String, String> emailToDelete = {'email': email};
    String url = 'http://10.0.2.2:5000/delete_member';
    var jsonUserInfo = json.encode(emailToDelete);
    var response = await http.post('$url',
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonUserInfo);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("success");
    } else {
      print("something wrong with flask server");
    }
  }

  static Future notifyViaCloudMessaging(
      {@required List tokens,
      @required String message,
      @required String title}) async {
    String url = 'http://10.0.2.2:5000/notify_all';
    Map<String, dynamic> dataToPost = {
      'tokens': tokens,
      'message': message,
      'title': title
    };
    var jsonTokens = json.encode(dataToPost);
    var response = await http.post('$url',
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonTokens);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("succesfully multicasted notification");
    } else {
      print("something wrong with flask server");
    }
  }

  Future createFirebaseAuthUser(
      {@required String email,
      @required String password,
      @required String username}) async {
    Map<String, String> userInfo = {
      "email": email,
      "password": password,
      "displayname": username
    };
    String url = 'http://10.0.2.2:5000/create_member';
    var jsonUserInfo = json.encode(userInfo);
    var response = await http.post('$url',
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonUserInfo);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("success");
    } else {
      print("something wrong with flask server");
    }
    //Save in DB
  }

  static Future setDefaultSchedule(Map<String, dynamic> request) async {
    String url = 'http://10.0.2.2:5000/set_default_schedule';
    var jsonUserInfo = json.encode(request);
    var response = await http.post('$url',
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonUserInfo);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("succesfully updated default schedule");
    } else {
      print("something wrong with flask server");
    }
  }
}
