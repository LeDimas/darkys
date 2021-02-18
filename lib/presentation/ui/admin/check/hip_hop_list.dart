import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darky_app/models/member.dart';
import 'package:darky_app/services/check_service.dart';

import 'package:flutter/material.dart';

class HipHopListPage extends StatefulWidget {
  final List<Member> members;

  HipHopListPage(this.members);
  @override
  _HipHopListPage createState() => _HipHopListPage(members);
}

class _HipHopListPage extends State<HipHopListPage> {
  List<Member> members;
  bool notCheckedToday = true;
  List<String> presentList = List();
  List<String> absentList = List();
  _HipHopListPage(this.members);
  @override
  void initState() {
    CheckService.isTodayListCheckedStream.listen((event) {
      var doc = event as DocumentSnapshot;
      var timestamp = doc.data()['hiphop'] as Timestamp;

      if (timestamp != null) {
        var date = timestamp.toDate();
        setState(() {
          notCheckedToday = (DateTime.now().difference(date).inHours > 1);
        });
      }
    });

    members = members
        .where((member) => member.section.contains('hiphop_section'))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6DC0C4),
        centerTitle: true,
        title: Text("Hip-Hop saraksts"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 32.0,
            ),
            child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                    color: Color(0xff7E8AA2),
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      padding: EdgeInsets.all(16.0),
                      child: notCheckedToday
                          ? ListView.builder(
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                var item = members[index];
                                return Dismissible(
                                    child: ListTile(
                                        title: Text("${members[index].name}")),
                                    secondaryBackground: Container(
                                        alignment: Alignment.centerRight,
                                        decoration: BoxDecoration(
                                            color: Color(0xff3EA4A9),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Icon(
                                              Icons.thumb_up_alt_rounded,
                                              color: Colors.white,
                                            ))),
                                    background: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffD93731),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.dangerous,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    key: Key(item.name),
                                    onDismissed: (DismissDirection dir) {
                                      dir == DismissDirection.startToEnd
                                          ? absentList.add(item.email)
                                          : presentList.add(item.email);
                                      setState(() {
                                        this.members.removeAt(index);
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              dir == DismissDirection.startToEnd
                                                  ? "absent"
                                                  : "present"),
                                          action: SnackBarAction(
                                            label: "Cancel that",
                                            onPressed: () {
                                              setState(() {
                                                this
                                                    .widget
                                                    .members
                                                    .insert(index, item);
                                              });
                                            },
                                          ),
                                        ));
                                      });
                                    });
                              })
                          : Container(
                              width: MediaQuery.of(context).size.height / 1.5,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 200),
                                child: Text(
                                  "Checked!",
                                  textAlign: TextAlign.center,
                                ),
                              ))),
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF6DC0C4),
        child: Icon(
          Icons.ad_units,
          color: Colors.white,
        ),
        onPressed: () {
          print("Updating presence list...");
          CheckService.checkPeople(presentList, absentList)
              .then((value) => CheckService.fixHipHopTodayCheckList());
        },
      ),
    );
  }
}

//   Widget getBreakingCheckList() {
//     var widget = FutureBuilder(
//         future: DatabaseService.memberNonStream('bboy'),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             members = snapshot.data;

//           //   return ListView.builder(
//           //       itemCount: members.length,
//           //       itemBuilder: (context, index) {
//           //       String item = members[i];
//           //        return Dismissible(

//           //       });
//           // }

//           return Container(
//               child: Padding(
//             padding: const EdgeInsets.all(30),
//             child: Text(
//               "LOADING SCREENHOLDER",
//               style: TextStyle(fontSize: 30, color: Colors.white),
//             ),
//           ));
//         });

//     return widget;
//   }

//
