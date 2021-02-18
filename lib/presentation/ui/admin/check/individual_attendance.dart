import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darky_app/models/consts.dart';
import 'package:flutter/material.dart';

import 'package:darky_app/models/member.dart';
import 'package:darky_app/services/database_service.dart';

class IndividualAttendance extends StatefulWidget {
  IndividualAttendance({
    Key key,
    this.member,
  }) : super(key: key);
  final Member member;

  @override
  _IndividualAttendanceState createState() => _IndividualAttendanceState();
}

class _IndividualAttendanceState extends State<IndividualAttendance> {
  int month;

  @override
  void initState() {
    super.initState();
    month = DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6DC0C4),
          title: Text("Password recovery"),
        ),
        body: Stack(children: [
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
                      child: Column(children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              if (month == 1)
                                month = 12;
                              else
                                month--;
                              setState(() {});
                            }),
                        Text(month_lookup[month]),
                        IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              if (month == 12)
                                month = 1;
                              else
                                month++;
                              setState(() {});
                            }),
                      ],
                    ),
                    FutureBuilder(
                        future: DatabaseService.getAttendanceForMonth(
                            widget.member.email, month),
                        builder: (_, snp) {
                          if (snp.hasData &&
                              snp.connectionState == ConnectionState.done) {
                            var attendance = snp.data as List;
                            if (attendance.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (_, i) {
                                  var dateTimeStamp =
                                      attendance[i]['Date'] as Timestamp;
                                  var date = dateTimeStamp
                                      .toDate()
                                      .toLocal()
                                      .toString();
                                  return Container(
                                    height: 100,
                                    width: 200,
                                    color: Colors.cyan,
                                    child: Text(date +
                                        "  PRESENT ? = " +
                                        attendance[i]['Present'].toString()),
                                  );
                                },
                                itemCount: attendance.length,
                              );
                            } else
                              return Container(
                                width: 200,
                                height: 100,
                                child: Text("no data"),
                              );
                          }
                          return CircularProgressIndicator();
                        })
                  ]))))
        ]));
  }
}
