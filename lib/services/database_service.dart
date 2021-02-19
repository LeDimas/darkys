import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darky_app/models/consts.dart';
import 'package:rxdart/rxdart.dart';

import 'package:darky_app/models/mail.dart';
import 'package:darky_app/models/member.dart';
import 'package:darky_app/services/firebase_admin_apiManager.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:time_range_picker/time_range_picker.dart';

class DatabaseService {
  //collection reference
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference memberCollection = _db.collection("members");
  final CollectionReference paymentCollection = _db.collection("payment");
  final CollectionReference lessons = _db.collection("lessons");
  final CollectionReference sectionCollection = _db.collection("sections");

  String email;
  DatabaseService({this.email});

  //member list from firestorage snapshot
  // List<Member> _memberListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs
  //       .map(
  //         (doc) => Member(
  //             name: doc.data()['name'] ?? 'no name provided ',
  //             email: doc.data()['email'] ?? 'no email provided',
  //             section: doc.data()['role'] ?? 'no role '),
  //       )
  //       .toList();
  // }

  static Future<Member> getMember(String email) async {
    var mem = await _db.collection('members').doc(email).get();
    return Member(section: mem.data()['sections'], name: mem.data()['name']);
  }

  static Future notifyAll(
      {@required String message, @required String title}) async {
    var mems = await _db.collection('members').get();
    var tokens = mems.docs.map((e) => e.data()['token']).toList();
    ApiManager.notifyViaCloudMessaging(
        tokens: tokens, message: message, title: title);
  }

  static Future notifySingleAdressant(
      {@required String title,
      @required String message,
      @required email}) async {
    var mem = await _db.collection('members').doc(email).get();
    var token = mem.data()['token'];
    ApiManager.notifySingleAddressantViaCloudMessaging(
        title: title, message: message, token: token);
  }

  static Future notifyCoaches({
    @required String title,
    @required String message,
  }) async {
    var mems =
        await _db.collection('members').where('role', isEqualTo: 'coach').get();
    var tokens = mems.docs.map((e) => e.data()['token']).toList();
    ApiManager.notifyViaCloudMessaging(
        title: title, message: message, tokens: tokens);
  }

  static Future getHomework(
      {@required String section,
      @required String day,
      @required DateTime date}) async {
    var doc = await _db
        .collection('homework')
        .where('section', isEqualTo: section)
        .get();
    var homework = doc.docs
        .where((e) {
          var hwTimeStamp = e.data()['date'] as Timestamp;
          var hwDate = hwTimeStamp.toDate();
          if (date.difference(hwDate).inHours < 24 && e.data()['day'] == day) {
            print(date.difference(hwDate));
            return true;
          } else
            return false;
        })
        .map((e) => e.data()['info'])
        .toList();
    doc.docs.forEach((e) async {});
    if (homework.length < 1) {
      return ['no homework'];
    }
    return homework;
  }

//===================================ATTENDANCE SECTION============================================
  static Future setAttendance(String email, DateTime day, bool wasOrNot) async {
    if (wasOrNot) {
      var attendanceInfo = {
        "Date": day,
        "Present": wasOrNot,
        "ThisPayed": false,
        "Month": day.month
      };
      await _db
          .collection("members")
          .doc(email)
          .collection('attendance')
          .add(attendanceInfo);
    } else {
      var attendanceInfo = {
        "Date": day,
        "Present": wasOrNot,
        "Month": day.month
      };
      await _db
          .collection("members")
          .doc(email)
          .collection('attendance')
          .add(attendanceInfo);
    }

    //uniqueId or dd-mm-yyyy?
  }

  static Future updateSkills(
      {Map<String, dynamic> progressMap,
      Map<String, bool> learnedMap,
      String email,
      String section,
      int tier}) async {
    //i know its dumb

    progressMap.forEach((key, value) async {
      await _db
          .collection('members')
          .doc(email)
          .collection('progress')
          .doc(key)
          .update({'progress': value});
    });

    learnedMap.forEach((key, value) async {
      await _db
          .collection('members')
          .doc(email)
          .collection('progress')
          .doc(key)
          .update({'learned': value});
    });

    // var member = await _db.collection('member').doc(email).get();
    var movements =
        await _db.collection('members').doc(email).collection('progress').get();
    var deezMoves = movements.docs.where((moves) =>
        moves.data()['section'] == section && moves.data()['tier'] == tier);
    var totalCount = deezMoves.length;
    var learnedMoves =
        deezMoves.where((muv) => muv.data()['learned'] == true).length;

    if (learnedMoves / totalCount > 0.6) {
      tier++;
      await _db
          .collection('members')
          .doc(email)
          .update({'${tierMap[section]}': tier});
      await _generateDataOfNextTier(section, tier, email);
    }
  }

  static _generateDataOfNextTier(String section, int tier, String email) async {
    var videosCollection = await _db
        .collection('videos')
        .doc('tutorials')
        .collection('darkys')
        .get();
    var memberRef = _db.collection('members').doc(email);

    List<Map<String, dynamic>> progressData = [];

    var availibleVideos = videosCollection.docs
        .where((vid) =>
            vid.data()['section'] == section &&
            vid.data()['${tierMap[section]}'] == tier)
        .map((video) => {
              'tier': video.data()['${tierMap[section]}'],
              'section': section,
              'learned': false,
              'progress': 0,
              'name': video.id,
              'type': video.data()['type']
            })
        .toList();
    progressData.addAll(availibleVideos);

    progressData.forEach((rec) {
      memberRef.collection('progress').doc(rec['name']).set({
        'tier': rec['tier'],
        'learned': rec['learned'],
        'section': rec['section'],
        'progress': rec['progress']
      });
    });
  }

  static Future<List<Map<String, dynamic>>> getAttendanceForMonth(
      String email, int month) async {
    var query = await _db
        .collection("members")
        .doc(email)
        .collection('attendance')
        .where("Month", isEqualTo: month)
        .get();
    var list = query.docs
        .map((doc) =>
            {"Date": doc.data()["Date"], "Present": doc.data()["Present"]})
        .toList();

    return list ?? new List();
  }

  static Stream<List<Map<String, dynamic>>> getAttendanceForMonthStream(
      String email, int month) {
    return _db
        .collection('members')
        .doc(email)
        .collection('attendance')
        .where("Month", isEqualTo: month)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => {
                  "Date": doc.data()['Date'],
                  'Present': doc.data()['Present'],
                  'ThisPayed': doc.data()['ThisPayed']
                })
            .toList());
  }

//================================ATTENDANCE SECTION END==========================================================
  static Future<List<Member>> memberOfSection([String section]) async {
    var querySnap = await _db.collection("members").get();

    var memberList = querySnap.docs.map((doc) {
      var sec = doc.data()['sections'] ?? ['no section'];
      return Member(
          name: doc.data()['name'] ?? 'noname',
          email: doc.data()['email'] ?? 'no email',
          avatarUrl: doc.data()['avatar'] ?? no_avatar_image,
          section: sec);
    }).toList();

    if (section != null) {
      var sortedMemberList = memberList
          .where((member) => member.section.contains(section))
          .toList();
      return sortedMemberList;
    }
    return memberList;
  }

  //get members stream
  // Stream<List<Member>> get members {
  //   return memberCollection.snapshots().map(_memberListFromSnapshot);
  // }

  Future<dynamic> get memberSections async {
    var data = await _db.collection('members').doc(email).get();
    return data.data()['sections'];
  }

  static Future<dynamic> getMemberSections(String email) async {
    var doc = await _db.collection('members').doc(email).get();
    return doc.data()['sections'];
  }

  static Stream getMemberSectionsStream(String email) {
    return _db
        .collection('members')
        .doc(email)
        .snapshots()
        .map((doc) => doc.data()['sections']);
  }

  Future<void> setUserDataOnFirebase(String email, String name, bool isBboy,
      bool isHipHop, bool isMultiGroup) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    List<String> memberSections = [];

    if (isBboy) {
      memberSections.add('breaking_section');
    }
    if (isHipHop) {
      memberSections.add('hiphop_section');
    }
    if (isMultiGroup) {
      memberSections.add('multi_group_section');
    }

    Map<String, dynamic> userData = {
      "email": email,
      "name": name,
      "role": "member", //latter make it possible to choose
      "build_number": buildNumber,
      "xp": 0,
      "bboyTier": isBboy ? 0 : -1,
      'hiphopTier': isHipHop ? 0 : -1,
      'multigroupTier': isMultiGroup ? 0 : -1,
      "rank": 'newbie',
      "sections": memberSections,
      'elementsLearned': 0,
      'combosLearned': 0
    };

    final userRef = _db.collection('members').doc(email);
    await userRef.set(userData);

    await _saveDevice(email);
  }
  //==============================VIDEOS Storage actions VIDEOS =======================

//cascade operator zbs
  static Future<List<Map<String, dynamic>>> getMemberVideos(String email,
      {String membSec}) async {
    const temp = ['breaking_section', 'hiphop_section', 'multi_group_section'];
    var memDoc = await _db.collection('members').doc(email).get();
    var sections = memDoc.data()['sections'] as List;
    var memSecTier = {};
    QuerySnapshot memDocs;
    List<Map<String, dynamic>> availableVideoList = List();
    //geting all tiers and putting into map

    if (membSec == null) {
      for (var i = 0; i < temp.length; i++) {
        if (sections.contains(temp[i]))
          memSecTier['${temp[i]}'] = memDoc.data()['${tierMap[temp[i]]}'];
        else
          memSecTier['${temp[i]}'] = -1;
      }
      for (var i = 0; i < sections.length; i++) {
        memDocs = await _db
            .collection('videos')
            .doc('tutorials')
            .collection('darkys')
            .where('section', isEqualTo: sections[i])
            .get();
        var filtered = memDocs.docs.where((doc) =>
            doc.data()['${tierMap[sections[i]]}'] <=
            memSecTier['${sections[i]}']);
        var videos = filtered
            .map((doc) => {
                  'link': doc.data()['link'],
                  'youtube': doc.data()['youtube'] ?? false,
                  'tier': doc.data()['${tierMap[sections[i]]}'].toString(),
                  'section': doc.data()['section'],
                  'name': doc.id
                })
            .toList();

        availableVideoList.addAll(videos);
      }

      return availableVideoList;
    } else {
      int tier = memDoc.data()['${tierMap[membSec]}'];

      memDocs = await _db
          .collection('videos')
          .doc('tutorials')
          .collection('darkys')
          .where('section', isEqualTo: membSec)
          .get();
      var filtered = memDocs.docs
          .where((doc) => doc.data()['${tierMap[membSec]}'] <= tier);
      var videos = filtered
          .map((doc) => {
                'link': doc.data()['link'],
                'youtube': doc.data()['youtube'] ?? false,
                'tier': doc.data()['${tierMap[membSec]}'].toString(),
                'section': doc.data()['section'],
                'name': doc.id
              })
          .toList();
      return videos;
    }

    //!IMPORTANT FILTER TO GIVE OUT ONLY VIDEOS CORRESPONDING TO USERS TIER
  }

  static Future addVideoLink(
      {String url,
      String name,
      String section,
      int tier,
      String type,
      bool isYoutubeVid}) async {
    //!IMPORTANT : WHEN NEW ELEMENT IS ADDED DATA IS GENERATED FOR EVERY MEMBER THAT CAN LEAR THIS ELEMENT
    var mems = await _db
        .collection('members')
        .where('${tierMap[section]}', isGreaterThanOrEqualTo: tier)
        .get();
    mems.docs.forEach((mem) async {
      await _db
          .collection('members')
          .doc(mem.id)
          .collection('progress')
          .doc(name)
          .set({
        'learned': false,
        'progress': 0,
        'section': section,
        'tier': tier,
        'type': type
      });
    });

    await _db
        .collection('videos')
        .doc('tutorials')
        .collection('darkys')
        .doc(name)
        .set({
      "link": url,
      "section": section,
      'youtube': isYoutubeVid,
      '${tierMap[section]}': tier,
      'type': type,
      'date': DateTime.now()
    });
    print("successfuly added link to database");
  }

  static Stream getMemberProgress3({String email, String section}) {
    if (section == null) {
      var section = [];
      var pl = _db.collection('members').doc(email).snapshots();
      pl.throttle((doc) => section = doc.data()['sections']);
      var prog = _db
          .collection('members')
          .doc(email)
          .collection('progress')
          .where('section', isEqualTo: section)
          .snapshots()
          .map((event) => event.docs
              .map((doc) => {
                    'name': doc.id,
                    'learned': doc.data()['learned'],
                    'progress': doc.data()['progress'],
                    'section': doc.data()['section'],
                    'type': doc.data()['type']
                  })
              .toList());

      var types = getSectionMovesTypes(section: section.first);
      var tier = _db
          .collection('members')
          .doc(email)
          .snapshots()
          .map((event) => event.data()['${tierMap['$section']}']);

      var temp = _db
          .collection('videos')
          .doc('tutorials')
          .collection('darkys')
          .where('section', isEqualTo: section)
          .snapshots()
          .map((event) => event.docs.map((doc) {
                return {
                  'moveName': doc.id,
                  'moveSection': doc.data()['section'],
                  'moveTier': '${doc.data()[tierMap[doc.data()['section']]]}',
                  'moveType': doc.data()['type'],

                  // 'moveLogo': doc.data()['moveIcon'] == null
                  //     ? Image.asset('moveIcon')
                  //     : Image.network(doc.data()['moveIcon.png'])
                };
              }).toList());

      return prog.withLatestFrom3(
          types, temp, tier, (t, a, b, c) => [t, a, b, c]);
    }
    var prog = _db
        .collection('members')
        .doc(email)
        .collection('progress')
        .where('section', isEqualTo: section)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => {
                  'name': doc.id,
                  'learned': doc.data()['learned'],
                  'progress': doc.data()['progress'],
                  'section': doc.data()['section'],
                  'type': doc.data()['type']
                })
            .toList());

    var types = getSectionMovesTypes(section: section);
    var tier = _db
        .collection('members')
        .doc(email)
        .snapshots()
        .map((event) => event.data()['${tierMap['$section']}']);

    var temp = _db
        .collection('videos')
        .doc('tutorials')
        .collection('darkys')
        .where('section', isEqualTo: section)
        .snapshots()
        .map((event) => event.docs.map((doc) {
              return {
                'moveName': doc.id,
                'moveSection': doc.data()['section'],
                'moveTier': '${doc.data()[tierMap[doc.data()['section']]]}',
                'moveType': doc.data()['type'],

                // 'moveLogo': doc.data()['moveIcon'] == null
                //     ? Image.asset('moveIcon')
                //     : Image.network(doc.data()['moveIcon.png'])
              };
            }).toList());

    return prog.withLatestFrom3(
        types, temp, tier, (t, a, b, c) => [t, a, b, c]);
  }

  static Future deleteMember(String email) async {
    _db.collection('members').doc(email).delete();

    await ApiManager.deleteUserAccount(email: email);
  }

  static Stream getMemberProgress({String email, String section}) {
    _db
        .collection('members')
        .doc(email)
        .collection('progress')
        .where('section', isEqualTo: section)
        .snapshots()
        .first
        .then((value) =>
            value.size < 1 ? _initMemberProgressData(email: email) : null);

    var prog = _db
        .collection('members')
        .doc(email)
        .collection('progress')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => {
                  'name': doc.id,
                  'learned': doc.data()['learned'],
                  'progress': doc.data()['progress'],
                  'section': doc.data()['section']
                })
            .toList());

    return _db
        .collection('videos')
        .doc('tutorials')
        .collection('darkys')
        .where('section', isEqualTo: section)
        .snapshots()
        .map((event) => event.docs.map((doc) {
              return {
                'moveName': doc.id,
                'moveSection': doc.data()['section'],
                'moveTier': '${doc.data()[tierMap[doc.data()['section']]]}',
                'moveType': doc.data()['type'],

                // 'moveLogo': doc.data()['moveIcon'] == null
                //     ? Image.asset('moveIcon')
                //     : Image.network(doc.data()['moveIcon.png'])
              };
            }).toList())
        .withLatestFrom(prog, (t, s) => [t, s]);
  }

  static Future _initMemberProgressData({String email}) async {
    Map<String, int> memberTiers = {};

    var memberRef = _db.collection('members').doc(email);
    var member = await memberRef.get();
    List<Map<String, dynamic>> progressData = [];
    var videosCollection = await _db
        .collection('videos')
        .doc('tutorials')
        .collection('darkys')
        .get();
    var sections = member.data()['sections'] as List;

    if (sections.length > 1) {
      sections.forEach((sec) {
        memberTiers['${tierMap[sec]}'] = member.data()['${tierMap[sec]}'];
      });

      sections.forEach((sec) {
        var availibleVideos = videosCollection.docs
            .where((vid) =>
                vid.data()['section'] == sec &&
                vid.data()['${tierMap[sec]}'] <= memberTiers['${tierMap[sec]}'])
            .map((video) => {
                  'tier': video.data()['${tierMap[sec]}'],
                  'section': sec,
                  'learned': false,
                  'progress': 0,
                  'name': video.id
                })
            .toList();

        progressData.addAll(availibleVideos);
      });
    }

    if (sections.length == 1) {
      memberTiers['${tierMap[sections.first]}'] =
          member.data()['${tierMap[sections.first]}'];
      var availibleVideos = videosCollection.docs
          .where((vid) =>
              vid.data()['section'] == sections.first &&
              vid.data()['${tierMap[sections.first]}'] <=
                  memberTiers['${tierMap[sections.first]}'])
          .map((video) => {
                'tier': video.data()['${tierMap[sections.first]}'],
                'section': sections.first,
                'learned': false,
                'progress': 0,
                'name': video.id
              })
          .toList();
      progressData.addAll(availibleVideos);
    }

    progressData.forEach((rec) {
      memberRef.collection('progress').doc(rec['name']).set({
        'tier': rec['tier'],
        'learned': rec['learned'],
        'section': rec['section'],
        'progress': rec['progress']
      });
    });

    print("initiliazied progress collection");
  }

  static Future<List<Map<String, dynamic>>> getVideos([String section]) async {
    if (section != null && section != "") {
      var temp = await _db
          .collection('videos')
          .doc('tutorials')
          .collection('darkys')
          .where("section", isEqualTo: section)
          .get();

      return temp.docs.map((doc) {
        var tempSec = doc.data()['section'];

        return {
          'link': doc.data()['link'],
          'youtube': doc.data()['youtube'] ?? false,
          'tier': doc.data()['${tierMap[tempSec]}'],
          'name': doc.id
        };
      }).toList();
    } else {
      var temp = await _db
          .collection('videos')
          .doc('tutorials')
          .collection('darkys')
          .get();
      return temp.docs.map((doc) {
        var tempSec = doc.data()['section'];
        return {
          'link': doc.data()['link'],
          'youtube': doc.data()['youtube'] ?? false,
          'tier': doc.data()['${tierMap[tempSec]}'],
          'name': doc.id
        };
      }).toList();
    }
  }

  static Future deleteVideoFromFirestore(String name) async {
    await _db
        .collection('videos')
        .doc('tutorials')
        .collection('darkys')
        .doc(name)
        .delete()
        .then((value) => print("video deleted from firestore"));
  }

  //====================================================================

  //===========================Set paying data ========================
  static Future addBill(DateTime date, String email) async =>
      _db.collection("members").doc(email).collection("payment").add({
        "Payed": false, //false
        "Month": date.month,
        "Date": date
      });

  static Future toggleIndividualLessonStatus(
      {bool payed, String email, DateTime date}) async {
    var lesson = await _db
        .collection('members')
        .doc(email)
        .collection('attendance')
        .where("Date", isEqualTo: date)
        .get();

    await _db
        .collection('members')
        .doc(email)
        .collection('attendance')
        .doc(lesson.docs.first.id)
        .update({'ThisPayed': !payed});
  }

  static Future toggleMonthPay({int month, String email, bool payed}) async {
    var lesson = await _db
        .collection('members')
        .doc(email)
        .collection('payment')
        .where("Month", isEqualTo: month)
        .get();
    var id = lesson.docs.first.id;
    await _db
        .collection('members')
        .doc(email)
        .collection('payment')
        .doc(id)
        .update({"Payed": payed});
  }

  static Stream hasPayed({int month, String email}) {
    return _db
        .collection('members')
        .doc(email)
        .collection('payment')
        .where('Month', isEqualTo: month)
        .snapshots()
        .map((querySnap) =>
            querySnap.docs.map((e) => e.data()['Payed']).toList());
  }

  static Future<QuerySnapshot> getBillings(int month, String email,
          {bool monthPay = true}) async =>
      await _db
          .collection("members")
          .doc(email)
          .collection("payment")
          .where('Month', isEqualTo: month)
          .get();

  static Future generateMonthBills() async {
    List<String> emails = List();

    //correct that tho
    var memCol = _db.collection("members").where("sections", isNotEqualTo: " ");
    var dancers = await memCol.get();
    dancers.docs.forEach((element) {
      addBill(DateTime.now(), element.data()['email']);
    });
    _db
        .collection("payment")
        .doc(DateTime.now().month.toString())
        .set({"generated": true});

    print(emails);
  }

//============================================PAYING==================================================================

//============================================FCM===================================================

  static Future registerDeviceFCMToken({String token, String email}) async {
    if (token != null) {
      await _db.collection('members').doc(email).update({'token': token});
    }
  }

//==================================================================================================

  static Future<void> checkUserLogin(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    Map<String, dynamic> userData = {
      "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      "build_number": buildNumber
    };
    final userRef = _db.collection('members').doc(user.email);
    userRef.update(userData);
  }

  static _saveDevice(String email) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId;
    Map<String, dynamic> deviceData;
    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": "android",
        "model": deviceInfo.model,
        "device": deviceInfo.device
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        'os_version': deviceInfo.systemVersion,
        'platform': 'ios',
        'model': deviceInfo.model,
        'device': deviceInfo.name
      };
    }

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection('members')
        .doc(email)
        .collection('devices')
        .doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({"updated_at": nowMs, "uninstalled": false});
    } else {
      await deviceRef.set({
        "created_at": nowMs,
        "updated_at": nowMs,
        'uninstalled': false,
        'id': deviceId,
        'device_info': deviceData
      });
    }
  }

//obsolete
  Future updateDanceSection(
      bool isBboy, bool isHipHoper, bool isMultiGroup) async {
    if (isBboy) {
      await sectionCollection
          .doc('bboy_section')
          .collection("bboys")
          .doc(email)
          .set({'email': email});
    } else {
      await sectionCollection
          .doc('bboy_section')
          .collection('bboys')
          .doc(email)
          .delete();
    }

    if (isHipHoper) {
      await sectionCollection
          .doc('hiphop_section')
          .collection('hiphopers')
          .doc(email)
          .set({'email': email});
    } else {
      await sectionCollection
          .doc('hiphop_section')
          .collection('hiphopers')
          .doc(email)
          .delete();
    }

    if (isMultiGroup) {
      await sectionCollection
          .doc('multi_group_section')
          .collection('multi_group')
          .doc(email)
          .set({'email': email});
    } else {
      await sectionCollection
          .doc('multi_group_section')
          .collection('multi_group')
          .doc(email)
          .delete();
    }
  }

  //=========================Section for lesson data managing below=================================

  static Stream getDefSched([String section]) {
    return _db
        .collection('lessons')
        .doc('default')
        .collection(section)
        .doc(section)
        .snapshots();
  }

  static Future<Map<String, dynamic>> getDefaultSchedule(
      [String section]) async {
    var snap = _db.collection("lessons").doc('default').collection(section);
    var danceSectionSched = await snap.doc(section).get();
    List sectionDays = danceSectionSched.data()['Days'];
    var sectionFromTime =
        danceSectionSched.data()['From'].toString().split(':');
    var fromHour = int.parse(sectionFromTime.first);
    var fromMinute = int.parse(sectionFromTime.last);
    var sectionToTime = danceSectionSched.data()['To'].toString().split(':');
    var toHour = int.parse(sectionToTime.first);
    var toMinute = int.parse(sectionToTime.last);
    var fromTime = TimeOfDay(hour: fromHour, minute: fromMinute);
    var toTime = TimeOfDay(hour: toHour, minute: toMinute);
    var time = TimeRange(startTime: fromTime, endTime: toTime);

    var defaultSchedule = {"Days": sectionDays, "Time": time};

    return defaultSchedule;
  }

  //Sets schedule via flask

  static Future setDefaultSchedule(
      {@required List<bool> days,
      @required TimeOfDay beginOfLesson,
      @required TimeOfDay endOfLesson,
      @required String section}) async {
    var end =
        endOfLesson.hour.toString() + " : " + endOfLesson.minute.toString();
    var start =
        beginOfLesson.hour.toString() + " : " + beginOfLesson.minute.toString();

    List<String> dayz = List();
    for (var i = 0; i < days.length; i++) {
      if (days[i] == true) {
        dayz.add(dayData[i]);
      }
    }
    switch (section) {
      case "Breaking":
        section = "breaking_section";
        break;
      case "Hip-hop":
        section = "hiphop_section";
        break;
      case "Multi-Group":
        section = "multi_group_section";
        break;
    }

    var request = {"Section": section, "From": start, "To": end, "Days": dayz};
    await ApiManager.setDefaultSchedule(request);
  }

  //=============================Mail and infrostructure section ==============================================
  List<MailMessage> _mailListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => MailMessage(
            opened: doc.data()['Opened'],
            body: doc.data()['Body'],
            from: doc.data()['From'],
            date: doc.id,
            subject: doc.data()['Subject']))
        .toList();
  }

  static Stream getUnreadMessagesCount(String email) {
    var count = _db
        .collection('members')
        .doc(email)
        .collection('mail')
        .where("Opened", isEqualTo: false)
        .snapshots();
    return count;
  }

  static Future deleteMailMessage({String date, String email}) async {
    await _db
        .collection('members')
        .doc(email)
        .collection('mail')
        .doc(date)
        .delete();
  }

  static Future<void> setMailMessageAsOpened(
      {String email, String date}) async {
    await _db
        .collection('members')
        .doc(email)
        .collection('mail')
        .doc(date)
        .update({"Opened": true});
  }

  Stream<List<MailMessage>> getMailContent(String email) {
    return _db
        .collection('members')
        .doc(email)
        .collection('mail')
        .snapshots()
        .map(_mailListFromSnapshot);
  }

  Stream<List<MailMessage>> checkForUnread(String email) {
    return _db
        .collection('members')
        .doc(email)
        .collection('mail')
        .snapshots()
        .map(_mailListFromSnapshot);
  }

  //=========================AVATAR AVATAR AVATAR =========================================================

  static Future setAvatar({String email, String url}) async {
    await _db.collection('members').doc(email).update({"avatar": url});
  }

  static Stream getAvatar({String email}) {
    return _db
        .collection('members')
        .doc(email)
        .snapshots()
        .map((doc) => doc.data()['avatar']);
  }
//============================================================================================================

//========================FEED FEED FEED FEED FEED FEED =======================================================

  Stream get getPosts {
    //Map later
    return _db.collection('feed').snapshots();
  }

  static Future deletePost({@required String title}) async {
    await _db.collection('feed').doc(title).delete();
  }

  static Future publishPost(
      {String title,
      String content,
      String image,
      String backgroundImage,
      bool notify}) async {
    _db.collection('feed').doc(title).set({
      "title": title,
      'image': image,
      'background': backgroundImage,
      'content': content,
      'date': DateTime.now()
    });
  }

//=========================================================================================================\\

//==========================XP RANK TIER(?????) ===========================================================\\
  static Stream getUserXp(String email) {
    return _db
        .collection('members')
        .doc(email)
        .snapshots()
        .map((doc) => [doc.data()['xp'], doc.data()['rank']]);
  }

  static Future incereaseXP(String email) async {
    var snap = await _db.collection('members').doc(email).get();
    var oldXp = snap.data()['xp'];
    var rank = snap.data()['rank'] as String;

    var newXp = oldXp + 10;
    if (titleXpThreshold[rank] < newXp) {
      var newRank = titleLeveledUpTitleMap[rank];
      _db
          .collection('members')
          .doc(email)
          .update({'xp': newXp, 'rank': newRank});
    } else {
      _db.collection('members').doc(email).update({'xp': newXp});
    }
  }

//=================================================================================================================

  static Stream getSectionMovesTypes({String section}) {
    return _db
        .collection('movetypes')
        .where('section', isEqualTo: section)
        .snapshots()
        .map((event) => event.docs.map((e) => e.id).toList());
  }

  static Future getSectionMovesTypesFuture({String section}) async {
    return await _db
        .collection('movetypes')
        .where('section', isEqualTo: section)
        .get();
  }

  static Future addScheduledHomework(
      {@required String day,
      @required String section,
      @required String info,
      @required DateTime date,
      bool notify}) async {
    await _db
        .collection('homework')
        .add({'day': day, 'section': section, 'info': info, 'date': date});
    if (notify)
      notifySection(
          section: section,
          title: 'new homework for $section section!',
          info: info);
  }

  static Future notifySection(
      {@required String section,
      @required String info,
      @required title}) async {
    var mems = await _db
        .collection('members')
        .where('section', isEqualTo: section)
        .get();
    var tokens = mems.docs.map((e) => e.data()['token']).toList();
    ApiManager.notifyViaCloudMessaging(
        tokens: tokens, message: info, title: title);
  }

  static Future sendNoteTo(
      {String destination, String sub, String msg, String from}) async {
    if (destination != 'admin' && destination != 'coach') {
      await _db
          .collection('members')
          .doc(destination)
          .collection('mail')
          .doc(DateTime.now().toString())
          .set({
        "From": from,
        "Body": msg,
        "Subject": sub,
        "Opened": false,
        "Date": DateTime.now()
      });
    } else {
      var coaches = await _db
          .collection('members')
          .where("role", isEqualTo: 'coach')
          .get();
      coaches.docs.forEach((coach) {
        _db
            .collection('members')
            .doc(coach.id)
            .collection('mail')
            .doc(DateTime.now().toString())
            .set({
          "From": from,
          "Body": msg,
          "Subject": sub,
          "Opened": false,
          "Date": DateTime.now()
        });
      });
    }
  }
}
