import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darky_app/models/consts.dart';
import 'package:darky_app/presentation/ui/admin/check/add_feed.dart';
import 'package:darky_app/presentation/ui/admin/check/date.dart';
import 'package:darky_app/services/helper.dart';
import 'package:darky_app/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:darky_app/presentation/ui/admin/register.dart';
import 'package:darky_app/presentation/ui/admin/student.dart';
import 'package:darky_app/presentation/ui/member/mail.dart';

import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/providers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  final String role;

  const HomePage({
    Key key,
    this.role,
  }) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  int _selectedItemIndex = 0;
  final ImagePicker _picker = ImagePicker();
  File _imageFile;
  Stream stream;
  String role;
  DateTime today;
  TextEditingController _hwController = TextEditingController();
  int unreadMessages = 0;
  String firstDateOfWeek;
  String lastDateOfWeek;
  List sections = [];
  static const Map<String, String> dayLookup = {
    "breaking_section": "Breaking",
    "hiphop_section": "Hip-Hop",
    "multi_group_section": "Mulit-Group"
  };

  FlutterLocalNotificationsPlugin notifications;

  @override
  void dispose() {
    super.dispose();
  }

  void _onImageButtonPressed(ImageSource source, BuildContext context) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      FireStorageService.uploadAvatarToFirebaseStorage(
          uploadMe: _imageFile,
          email: context.read(authenticationServiceProvider).currentUserEmail);
    }
  }

  _getSection() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    var doc = await _db
        .collection('members')
        .doc(context.read(authenticationServiceProvider).currentUserEmail)
        .get();
    return doc.data()['sections'] ?? [];
  }

  @override
  void initState() {
    role = widget.role;
    today = DateTime.now();

    firstDateOfWeek = _findFirstDateOfTheWeek(today);

    lastDateOfWeek = _findLastDateOfTheWeek(today);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "DARKY'S",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Color(0xFF6DC0C4),
          actions: <Widget>[
            _mailUnreadMessages(context),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => MailPage()));
                },
                child: Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read(authenticationServiceProvider).signOut();
              },
              child: Icon(
                Icons.logout,
                color: Colors.red,
                size: 30,
              ),
            )
          ],
        ),
        drawer: widget.role == 'member' ? null : _homeDrawer(context),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                  height: MediaQuery.of(context).size.height * 2,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: StreamBuilder(
                            stream: DatabaseService.getAvatar(
                                email: context
                                    .read(authenticationServiceProvider)
                                    .currentUserEmail),
                            builder: (_, snap) {
                              if (snap.hasData &&
                                  snap.connectionState ==
                                      ConnectionState.active) {
                                var url = snap.data as String;

                                return GestureDetector(
                                  onLongPress: () {
                                    _onImageButtonPressed(
                                        ImageSource.gallery, context);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(url),
                                    backgroundColor: Colors.red,
                                    radius: 64,
                                  ),
                                );
                              }
                              return GestureDetector(
                                onLongPress: () {
                                  _onImageButtonPressed(
                                      ImageSource.gallery, context);
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(no_avatar_image),
                                  backgroundColor: Colors.red,
                                  radius: 64,
                                ),
                              );
                            },
                          )),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                context
                                    .read(authenticationServiceProvider)
                                    .currentUserEmail,
                                style: TextStyle(
                                  wordSpacing: 1.0,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                          Text(this.widget.role,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 5.0,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          role == 'member' ? _xpProgressBar() : Text(""),
                          Divider(
                            height: 60.0,
                            color: Colors.black54,
                          ),
                          Text(
                            "Treniņu grafiks",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: Color(0xff7E8AA2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0))),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Nedēļa",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                            icon:
                                                Icon(Icons.arrow_back_rounded),
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                today = _getPreviousWeek(today);
                                                firstDateOfWeek =
                                                    _findFirstDateOfTheWeek(
                                                        today);
                                                lastDateOfWeek =
                                                    _findLastDateOfTheWeek(
                                                        today);
                                              });
                                            }),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffF7EB7D),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16.0),
                                            )),
                                        child: Text(
                                          firstDateOfWeek +
                                              " - " +
                                              lastDateOfWeek,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                            icon: Icon(
                                                Icons.arrow_forward_rounded),
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                today = _getNextWeek(today);
                                                firstDateOfWeek =
                                                    _findFirstDateOfTheWeek(
                                                        today);
                                                lastDateOfWeek =
                                                    _findLastDateOfTheWeek(
                                                        today);
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                  _generateSchedule(),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  role == 'member'
                                      ? _payementStatusPanel()
                                      : SizedBox(
                                          height: 100,
                                          width: 100,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ]),
                  )))
        ]));
  }

  Widget _payementStatusPanel() {
    return StreamBuilder(
        builder: (_, snap) {
          if (snap.hasData && snap.connectionState == ConnectionState.active) {
            var values = snap.data as List;
            var payed = values.first as bool;

            return payed
                ? Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.green,
                        size: 40,
                      ),
                      Text(
                        "Payed this month",
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.red,
                        size: 40,
                      ),
                      Text(
                        "Not payed this month",
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  );
          }
          return CircularProgressIndicator();
        },
        stream: DatabaseService.hasPayed(
            month: DateTime.now().month,
            email:
                context.read(authenticationServiceProvider).currentUserEmail));
  }

  Widget buildNavBarItem(
    BuildContext context,
    IconData icon,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: new Container(
        height: 64.0,
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
          color: index == _selectedItemIndex
              ? Color(0xFF6DC0C4)
              : Color(0xff7E8AA2),
        ),
        child: Icon(
          icon,
          color: index == _selectedItemIndex ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  Widget _xpProgressBar() {
    return StreamBuilder(
        builder: (_, snap) {
          if (snap.hasData && snap.connectionState == ConnectionState.active) {
            var xp = snap.data as List;

            print(xp);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: LinearProgressIndicator(
                    value: xp[0].toDouble() * titleXpKMap[xp[1]],
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    backgroundColor: Colors.cyanAccent,
                  ),
                ),
                Text(
                  xp[1],
                  style: TextStyle(fontSize: 24),
                ),
                Text(xp[0].toString() +
                    " / " +
                    titleXpThreshold[xp[1]].toString())
              ],
            );
          }
          return SizedBox();
        },
        stream: DatabaseService.getUserXp(
            context.read(authenticationServiceProvider).currentUserEmail));
  }

  Widget _generateSchedule() {
    return FutureBuilder(
      builder: (_, snap) {
        Stream streamOfMySchedule;

        if (snap.hasData && snap.connectionState == ConnectionState.done) {
          sections = snap.data;

          streamOfMySchedule = Helper.instance.provideMemberScheduleStream(
              role: widget.role, sections: sections);

          return StreamBuilder(
            builder: (_, snap) {
              var dayList = List<String>();
              var data = List();
              if (snap.hasData &&
                  snap.connectionState == ConnectionState.active) {
                if (snap.data is DocumentSnapshot) {
                  data.add(snap.data);
                } else {
                  data = snap.data as List;
                }

                if (data.first is DocumentSnapshot && data.length == 2) {
                  data = [data[0], data[1]];
                }
                if (data.length == 2 && !(data.first is DocumentSnapshot)) {
                  List temp = List.from(data);
                  data.clear();
                  data.add(temp[0][0]);
                  data.add(temp[0][1]);
                  data.add(temp[1]);
                }

                for (var i = 0; i < data.length; i++) {
                  var doc = data[i] as DocumentSnapshot;

                  var docsDays = doc.data()['Days'] as List;
                  docsDays.forEach((day) {
                    dayList.add(day);
                  });
                }
                var uniqueDays = dayList.toSet();
                var days = uniqueDays.toList();
                var scheduleMap = Map<String, Map<String, String>>();
                days.forEach((day) {
                  Map temp = Map<String, String>();
                  for (var i = 0; i < data.length; i++) {
                    var doc = data[i] as DocumentSnapshot;
                    var docsDays = doc.data()['Days'] as List;
                    if (docsDays.contains(day)) {
                      temp[doc.id] =
                          doc.data()['From'] + " - " + doc.data()['To'];
                    }
                  }
                  scheduleMap[day] = temp;
                });

                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, i) {
                    var sections = scheduleMap[days[i]].keys.toList();
                    var times = scheduleMap[days[i]].values.toList();

                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 48.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                days[i],
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xffF7EB7D),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )),
                              padding: EdgeInsets.all(8.0),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          var notify = false;
                          var date = today
                              .subtract(Duration(days: today.weekday - 1))
                              .add(Duration(
                                  days: date_lookup['${days[i]}'] - 1));
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: Column(
                              children: [
                                Text(dayLookup[sections[index]] +
                                    " is at " +
                                    times[index]),
                                role == "member"
                                    ? Container(
                                        child: FutureBuilder(
                                            future: DatabaseService.getHomework(
                                                section: sections[index],
                                                day: days[i],
                                                date: date),
                                            builder: (context, snp) {
                                              if (snp.hasData &&
                                                  snp.connectionState ==
                                                      ConnectionState.done) {
                                                var ok = snp.data as List;
                                                return Column(
                                                  children: [
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Homework',
                                                            style: TextStyle(
                                                                fontSize: 24),
                                                          ),
                                                          Container(
                                                            height: 100,
                                                            child: Text(
                                                              ok.first,
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                              return Column(
                                                children: [
                                                  Text(
                                                    'Homework',
                                                    style:
                                                        TextStyle(fontSize: 24),
                                                  ),
                                                  Container(
                                                    height: 100,
                                                    child: Text(
                                                      "No homework",
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      )
                                    : Column(
                                        children: [
                                          TextField(
                                              controller: _hwController,
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: "type",
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .deepPurple,
                                                              width: 3)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .lightBlue,
                                                                  width: 3)))),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RaisedButton(
                                                onPressed: () {
                                                  DatabaseService
                                                      .addScheduledHomework(
                                                          day: days[i],
                                                          section:
                                                              sections[index],
                                                          info: _hwController
                                                              .text,
                                                          date: date,
                                                          notify: notify);

                                                  _hwController.clear();
                                                },
                                                color: Colors.deepOrange[100],
                                                child: Text(
                                                  'Add collective homework?',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                              Checkbox(
                                                  value: notify,
                                                  onChanged: (val) {
                                                    notify = val;
                                                  }),
                                              Text("notify?")
                                            ],
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          );
                        },
                        itemCount: sections.length,
                      )
                    ]);
                  },
                  itemCount: days.length,
                );
              }
              return Text("wait for it..");
            },
            stream: streamOfMySchedule,
          );
        }
        return Text("You are not in any of sections");
      },
      future: _getSection(),
    );
  }

  Widget buildMessageContainer(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => StudentPage()));
      },
      child: new Container(
          height: 48.0,
          width: MediaQuery.of(context).size.width / 1.4,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Text(
            "Vārds, Uzvārds",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  String _findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .subtract(Duration(days: dateTime.weekday - 1))
        .toLocal()
        .toString()
        .substring(5, 10)
        .replaceAll('-', '.');
  }

  String _findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday))
        .toLocal()
        .toString()
        .substring(5, 10)
        .replaceAll('-', '.');
  }

  DateTime _getPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek =
        dateTime.subtract(const Duration(days: 7));

    return sameWeekDayOfLastWeek;
  }

  DateTime _getNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek = dateTime.add(Duration(days: 7));

    return sameWeekDayOfNextWeek;
  }
}

Widget _mailUnreadMessages(BuildContext context) {
  return StreamBuilder(
      stream: DatabaseService.getUnreadMessagesCount(
          context.read(authenticationServiceProvider).currentUserEmail),
      builder: (_, snap) {
        if (snap.hasData && snap.connectionState == ConnectionState.active) {
          var querySnap = snap.data as QuerySnapshot;
          var unreadMessageAmount = querySnap.size;
          if (unreadMessageAmount < 1) {
            return Text("");
          }
          if (unreadMessageAmount > 0) {
            return Text(
              unreadMessageAmount.toString(),
              style: TextStyle(backgroundColor: Colors.red),
            );
          }
        }
        return Text("");
      });
}

Widget _homeDrawer(BuildContext context) => Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Material(
                  child: Image.asset(
                    "lib/assets/download.png",
                    width: 96,
                    height: 96,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF6DC0C4),
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.notifications),
          //   title: Text("Notifications"),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         new MaterialPageRoute(
          //             builder: (context) => NotificationPage()));
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.fact_check_outlined),
            title: Text("Open todays check-list"),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => DatePage()));
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text("Test"),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         new MaterialPageRoute(
          //             builder: (context) => LocalNotificationScreen()));
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Add an announcements"),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (_) => AddToFeedPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.create, color: Colors.red),
            title: Text("Register new member"),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (_) => RegisterMemberPage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text("Logout"),
            onTap: () {
              context.read(authenticationServiceProvider).signOut();
            },
          ),
        ],
      ),
    );
