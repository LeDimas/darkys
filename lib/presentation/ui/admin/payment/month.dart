import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darky_app/models/consts.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:flutter/material.dart';

class MonthPage extends StatefulWidget {
  final int month;
  final String email;

  const MonthPage({Key key, this.month, this.email});
  @override
  _MonthPageState createState() => _MonthPageState(month: month, email: email);
}

class _MonthPageState extends State<MonthPage> {
  int month;
  String email;
  List<Map<String, dynamic>> unitList = List();
  _MonthPageState({this.month, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atsevišķi maksājumi mēnesī"),
        backgroundColor: Color(0xFF6DC0C4),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF263248),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 32,
            ),
            Center(
              child: Text(
                "MĒNEŠA MAKSĀJUMI",
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                color: Color(0xff7E8AA2),
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        print(await DatabaseService.getAttendanceForMonth(
                            email, month));
                      },
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    month_lookup[month],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  StreamBuilder(
                    builder: (_, snap) {
                      if (snap.hasData &&
                          snap.connectionState == ConnectionState.active) {
                        var data = snap.data as List<Map<String, dynamic>>;
                        print(data);

                        if (data.any((map) => map['ThisPayed'] == false)) {
                          DatabaseService.toggleMonthPay(
                              month: month, email: email, payed: false);
                        }
                        if (data.every((map) => map['ThisPayed'] == true)) {
                          DatabaseService.toggleMonthPay(
                              month: month, email: email, payed: true);
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return _attendanceCheckTile(data[index]);
                            });
                      }
                      return CircularProgressIndicator();
                    },
                    stream: DatabaseService.getAttendanceForMonthStream(
                        email, month),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _attendanceCheckTile(Map<String, dynamic> datePresence) {
    var timestamp = datePresence['Date'] as Timestamp;
    var payed = datePresence['ThisPayed'] as bool;
    var date = timestamp.toDate();
    var dateToShow = date.day.toString() + ". " + month_lookup[date.month];

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: GestureDetector(
        onLongPress: () {},
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
              title: Text(
                dateToShow.toString(),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                date.year.toString(),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.monetization_on_outlined,
                    color: payed ? Colors.green : Colors.red),
                onPressed: () {
                  DatabaseService.toggleIndividualLessonStatus(
                      date: date, payed: payed, email: email);
                },
              )

              // GestureDetector(
              //   child: Icon(
              //     Icons.delete,
              //     color: Colors.red[900],
              //   ),
              //   onTap: () async {
              //     DatabaseService.setAttendance(
              //         'lol@gmail.com', DateTime.now(), true);
              //   },
              // ),
              ),
        ),
      ),
    );
  }
}
