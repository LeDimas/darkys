import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:darky_app/services/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:darky_app/services/fcm/notfication_plugin.dart';

import '../database_service.dart';

// class NotificationHandler {
//   static final flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static BuildContext myContext;

//   static void initNotification(BuildContext context) {
//     myContext = context;
//     var initAndroid = AndroidInitializationSettings('app_icon');
//     var initIOS = IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     var initSetting =
//         InitializationSettings(android: initAndroid, iOS: initIOS);
//     flutterLocalNotificationsPlugin.initialize(initSetting,
//         onSelectNotification: onSelectNotification);
//   }

//   static Future onSelectNotification(String payload) async {
//     if (payload != null) {
//       print("notification payload:" + payload);
//     }
//   }

//   // ignore: missing_return
//   static Future<void> onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) {
//     showDialog(
//         context: myContext,
//         builder: (BuildContext context) => CupertinoAlertDialog(actions: [
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 child: Text("ok"),
//                 onPressed: () {
//                   print('Click notification');
//                   Navigator.of(context, rootNavigator: true).pop();
//                 },
//               )
//             ], content: Text(body), title: Text(title)));
//   }
// }

class FirebaseNotifications {
  FirebaseMessaging _messaging;
  BuildContext myContext;

  void setupFirebase(BuildContext context) async {
    _messaging = FirebaseMessaging();
    // NotificationHandler.initNotification(context);
    firebaseCloudMessagingListener(context);
    myContext = context;
    String email = context.read(authenticationServiceProvider).currentUserEmail;
    String fcmToken = await _messaging.getToken();
    DatabaseService.registerDeviceFCMToken(token: fcmToken, email: email);
  }

  void firebaseCloudMessagingListener(BuildContext context) {
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _messaging.onIosSettingsRegistered.listen((event) {
      print("setting registered $event");
    });
    _messaging.getToken().then((value) => print('Token : $value '));

    // _messaging
    //     .subscribeToTopic('testTopic')
    //     .whenComplete(() => print("Subscribe OK"));

    _messaging.configure(
        onBackgroundMessage: Platform.isIOS ? null : fcmBackroungMessageHandler,
        onMessage: (Map<String, dynamic> message) async {
          if (Platform.isAndroid) {
            notificationPlugin.showNotification(
                title: message['notification']['title'],
                body: message['notification']['body']);
          } else if (Platform.isIOS)
            notificationPlugin.showNotification(
                title: message['notification']['title'],
                body: message['notification']['body']);
        },
        onResume: (Map<String, dynamic> message) async {
          if (Platform.isIOS)
            showDialog(
                context: myContext,
                builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text(message['title']),
                      content: Text(message['body']),
                      actions: [
                        CupertinoDialogAction(
                          child: Text("ok"),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            print("click notification");
                          },
                        )
                      ],
                    ));
        },
        onLaunch: (Map<String, dynamic> message) async {});
  }

//ios
  static Future fcmBackroungMessageHandler(Map<String, dynamic> message) async {
    notificationPlugin.showNotification(
        title: message['notification']['title'],
        body: message['notification']['body']);

    return Future<void>.value();
  }
}
