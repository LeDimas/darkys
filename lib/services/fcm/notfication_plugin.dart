import 'dart:io';
import 'package:darky_app/services/fcm/timezone.dart';

import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class NotificationPlugin {
  FlutterLocalNotificationsPlugin _plugin;
  var initializationSettings;
  NotificationPlugin._() {
    init();
  }
  final BehaviorSubject<ReceivedNotification>
      didReiceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  init() async {
    _plugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializeSettingAndroid = AndroidInitializationSettings('app_icon');
    var initializeSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          //ios vers.
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, body: body, paylod: payload, title: title);
          didReiceivedLocalNotificationSubject.add(receivedNotification);
        });

    initializationSettings = InitializationSettings(
        iOS: initializeSettingIOS, android: initializeSettingAndroid);
  }

  setOnNotificationClick(Function onNotificationCLick) async {
    await _plugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationCLick(payload);
    });
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersion) {
    didReiceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersion(receivedNotification);
    });
  }

  _requestIOSPermission() {
    _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(
      {@required String title, @required String body}) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 4', 'CHANNEL_NAME 4 ', 'CHANNEL_DESCRIPTION 4',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true));
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecfifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await _plugin.show(0, title, body, platformChannelSpecfifics,
        payload: 'Test Payload');
  }

  Future<void> repeatNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 3', 'CHANNEL_NAME 3', 'CHANNEL_DESCRIPTION 3',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true));
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecfifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await _plugin.periodicallyShow(0, 'Test <b>Tile</b>', 'Test body',
        RepeatInterval.everyMinute, platformChannelSpecfifics,
        payload: 'Test Payload');
  }

  Future<void> cancelNotification() async {
    await _plugin.cancel(0);
  }

  Future<void> sheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    final timezone = TimeZone();
    String timeZoneName = await timezone.getTimeZoneName();
    final location = await timezone.getLocation(timeZoneName);
    final scheduleNotificationTZDateTime =
        tz.TZDateTime.from(scheduledNotificationDateTime, location);

    var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 1', 'CHANNEL_NAME 1', 'CHANNEL_DESCRIPTION 1',
        icon: 'app_icon',
        // largeIcon: DrawableResourceAndroidBitmap('lib/assets/home.png'),
        // sound: RawResourceAndroidNotificationSound('my_sound'),
        importance: Importance.max,
        enableLights: true,
        ledOnMs: 1000,
        ledOffMs: 500,
        color: const Color.fromARGB(255, 255, 0, 0),
        enableVibration: true,
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        priority: Priority.max,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true));
    var iosChannelSpecifics = IOSNotificationDetails(
        // sound: 'my_sound.aiff',
        );
    var platformChannelSpecfifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await _plugin.zonedSchedule(0, 'Test <b>Tile</b>', 'Test body',
        scheduleNotificationTZDateTime, platformChannelSpecfifics,
        payload: 'Test Payload',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  Future<void> showNotificationWithAttachment() async {
    var attachementPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/800x200', 'attachment_img.jpg');
    var iOSPlatformSpecifics = IOSNotificationDetails(
        attachments: [IOSNotificationAttachment(attachementPicturePath)]);
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(attachementPicturePath),
        summaryText: 'Test Image',
        htmlFormatSummaryText: true,
        htmlFormatContent: true,
        contentTitle: '<b>Attachement image</b>');

    var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 2', 'CHANNEL_NAME 2', 'CHANNEL_DESCRIPTION 2',
        priority: Priority.max,
        importance: Importance.max,
        styleInformation: bigPictureStyleInformation);
    var notificationDetails = NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSPlatformSpecifics);
    await _plugin.show(0, 'Title with attachement', 'Body with attachement',
        notificationDetails);
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var dir = await getApplicationDocumentsDirectory();
    var filepath = '${dir.path}/$fileName';
    var response = await http.get(url);
    var file = File(filepath);
    await file.writeAsBytes(response.bodyBytes);
    return filepath;
  }
}

//mhm

//

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String paylod;

  ReceivedNotification(
      {@required this.id,
      @required this.body,
      @required this.paylod,
      @required this.title});
}
