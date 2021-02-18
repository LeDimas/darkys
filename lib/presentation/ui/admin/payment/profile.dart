import 'package:darky_app/models/member.dart';
import 'package:darky_app/presentation/ui/admin/check/individual_attendance.dart';
import 'package:darky_app/presentation/ui/admin/payment/month.dart';
import 'package:darky_app/presentation/ui/admin/skills/member_skill.dart';
import 'package:darky_app/services/check_service.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberProfilePage extends StatefulWidget {
  final Member member;

  const MemberProfilePage({Key key, this.member}) : super(key: key);
  @override
  _MemberProfilePageState createState() => _MemberProfilePageState(member);
}

class _MemberProfilePageState extends State<MemberProfilePage> {
  bool notifyCoaches = false;
  bool notifyStudent = false;
  bool monthPay = false;
  bool payed = false;
  bool changesMade = false;
  var monthMap = {
    1: "Janvaris",
    2: "Februaris",
    3: "Marts",
    4: "Aprilis",
    5: "Maijs",
    6: "Junijs",
    7: "Julijs",
    8: "Augusts",
    9: "Septembris",
    10: "Oktobris",
    11: "Novembris",
    12: "Decembris"
  };

  Member member;
  TextEditingController coachNoteController;
  TextEditingController memberNoteController;
  TextEditingController memberSubjectNoteController;
  TextEditingController memberTopicNoteController;
  TextEditingController coachSubjectNoteController;
  TextEditingController coachTopicNoteController;
  _MemberProfilePageState(this.member);
  String selectedMonthString;
  int selectedMonth;
  @override
  void initState() {
    memberNoteController = TextEditingController();
    memberTopicNoteController = TextEditingController();
    memberSubjectNoteController = TextEditingController();
    coachNoteController = TextEditingController();
    coachSubjectNoteController = TextEditingController();
    coachTopicNoteController = TextEditingController();

    selectedMonth = DateTime.now().month;
    selectedMonthString = monthMap[selectedMonth];
    CheckService.hasPayed(selectedMonth, member.email).then((value) {
      setState(() {
        payed = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6DC0C4),
          title: Text(member.name),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          Container(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        "MAKSĀJUMI",
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [_editButton()],
                                  ),
                                ),
                                Text(
                                  "Month/unit payment",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                _payingPanel(),
                                SizedBox(
                                  height: 16.0,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Manage Skills",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                          padding: EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              color: Color(0xff7E8AA2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Center(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            // SkillTreePage()
                                            MemberSkill(
                                                member: widget.member)));
                              },
                              color: Colors.purpleAccent[200],
                              child: Icon(
                                Icons.ac_unit,
                                color: Colors.amber[200],
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Overview attendance",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                          padding: EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              color: Color(0xff7E8AA2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Center(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            // SkillTreePage()
                                            IndividualAttendance(
                                                member: widget.member)));
                              },
                              color: Colors.purpleAccent[200],
                              child: Icon(
                                Icons.wysiwyg_outlined,
                                color: Colors.amber[200],
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Piezīmes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            color: Color(0xff7E8AA2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Piezīmes treneriem",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0))),
                                    child: Column(
                                      children: [
                                        TextField(
                                            controller:
                                                coachSubjectNoteController,
                                            decoration: InputDecoration(
                                                hintText: 'subject'),
                                            onSubmitted: (value) {
                                              print("adding note");
                                            }),
                                        TextField(
                                            controller: coachNoteController,
                                            decoration: InputDecoration(
                                                hintText: 'body'),
                                            onSubmitted: (value) {
                                              print("adding note");
                                            }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90))),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.add,
                                            ),
                                            onPressed: () {
                                              _sendMessageTo('coach');
                                              if (notifyCoaches)
                                                DatabaseService.notifyCoaches(
                                                  title:
                                                      coachSubjectNoteController
                                                          .text,
                                                  message:
                                                      coachNoteController.text,
                                                );
                                            }),
                                      ),
                                      Checkbox(
                                          value: notifyCoaches,
                                          onChanged: (val) {
                                            notifyCoaches = val;
                                          }),
                                      Text("notify?")
                                    ],
                                  ),
                                  Divider(
                                    height: 16.0,
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(
                                    "Piezīmes studentam",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                                    width:
                                        MediaQuery.of(context).size.width / 1.4,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0))),
                                    child: Column(
                                      children: [
                                        TextField(
                                            controller:
                                                memberSubjectNoteController,
                                            decoration: InputDecoration(
                                                hintText: 'subject'),
                                            onSubmitted: (value) {
                                              print("adding note");
                                            }),
                                        TextField(
                                            controller: memberNoteController,
                                            decoration: InputDecoration(
                                                hintText: 'body'),
                                            onSubmitted: (value) {
                                              print("adding note");
                                            }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90))),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.add,
                                            ),
                                            onPressed: () {
                                              _sendMessageTo(
                                                  this.widget.member.email);
                                              if (notifyStudent)
                                                DatabaseService
                                                    .notifySingleAdressant(
                                                        title:
                                                            coachSubjectNoteController
                                                                .text,
                                                        message:
                                                            coachNoteController
                                                                .text,
                                                        email: widget
                                                            .member.email);
                                            }),
                                      ),
                                      Checkbox(
                                          value: notifyStudent,
                                          onChanged: (val) {
                                            notifyStudent = val;
                                          }),
                                      Text("notify?")
                                    ],
                                  ),
                                  Divider(
                                    height: 16.0,
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32.0,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  _sendMessageTo(String destination) {
    var msg = destination == "coach" || destination == "admin"
        ? coachNoteController.text
        : memberNoteController.text;

    var sub = destination == "coach" || destination == "admin"
        ? coachSubjectNoteController.text
        : memberSubjectNoteController.text;

    DatabaseService.sendNoteTo(
        destination: destination,
        msg: msg,
        sub: sub,
        from: context.read(authenticationServiceProvider).currentUserEmail);
    if (destination != 'coach') {
      memberNoteController.clear();
      memberSubjectNoteController.clear();
    } else {
      coachNoteController.clear();
      coachSubjectNoteController.clear();
    }
  }

  _payingPanel() {
    return monthPay
        ? InkWell(
            onTap: () async {},
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width / 1.4,
              decoration: BoxDecoration(
                  color: Colors.greenAccent[100],
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _prevIconButton(),
                  Text(selectedMonthString),
                  StreamBuilder(
                    builder: (_, snap) {
                      if (snap.hasData &&
                          snap.connectionState == ConnectionState.active) {
                        var valuev = snap.data as List;
                        payed = valuev.first as bool;

                        return IconButton(
                            icon: payed
                                ? Icon(Icons.monetization_on_rounded)
                                : Icon(Icons.monetization_on_outlined),
                            color: payed ? Colors.green : Colors.red,
                            onPressed: () {
                              DatabaseService.toggleMonthPay(
                                  month: selectedMonth,
                                  email: member.email,
                                  payed: !payed);
                            });
                      }
                      return SizedBox();
                    },
                    stream: DatabaseService.hasPayed(
                        month: selectedMonth, email: member.email),
                  ),
                  _nextIconButton()
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () async {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => MonthPage(
                            month: selectedMonth,
                            email: member.email,
                          )));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width / 1.4,
              decoration: BoxDecoration(
                  color: Colors.blueAccent[100],
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _prevIconButton(),
                  Text(selectedMonthString),
                  _nextIconButton()
                ],
              ),
            ),
          );
  }

  _editButton() {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        setState(() {
          monthPay = !monthPay;
        });
      },
      color: Colors.white,
    );
  }

  _prevIconButton() {
    return FlatButton.icon(
      onPressed: () async {
        var temp = selectedMonth == 1 ? 12 : selectedMonth - 1;
        var mustPay = await CheckService.haveToPay(temp, member.email);
        if (mustPay) {
          if (selectedMonth == 1) {
            selectedMonth = 12;
          } else {
            selectedMonth -= 1;
          }
          setState(() {
            selectedMonthString = monthMap[selectedMonth];
          });
        } else
          print("no no no");
      },
      icon: Icon(Icons.arrow_back),
      label: Text(""),
      minWidth: 10,
    );
  }

  _nextIconButton() {
    return selectedMonth != DateTime.now().month
        ? FlatButton.icon(
            onPressed: () async {
              if (selectedMonth == 12) {
                selectedMonth = 1;
              } else {
                selectedMonth += 1;
              }

              setState(() {
                selectedMonthString = monthMap[selectedMonth];
              });
            },
            icon: Icon(Icons.arrow_forward),
            label: Text(""),
            minWidth: 10,
          )
        : SizedBox(
            width: 0,
          );
  }
}

// Widget _monthlyPayment() {
//   void month = Container(
//     width: MediaQuery.of(context).size.width / 1.2,
//     decoration: BoxDecoration(
//       color: Color(0xff7E8AA2),
//       borderRadius: BorderRadius.all(Radius.circular(16.0)),
//     ),
//     child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//       Column(children: [
//         Row(
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: Icon(
//                 Icons.edit,
//                 color: Colors.white,
//               ),
//             )
//           ],
//         ),
//         Text(
//           "Mēnesis",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(
//           height: 16.0,
//         ),
//         Container(
//           padding: EdgeInsets.all(16.0),
//           height: MediaQuery.of(context).size.height / 8,
//           width: MediaQuery.of(context).size.width / 1.4,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(16))),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [Text("Septembris")],
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [Icon(Icons.circle), Text("Apmaksāts")],
//               ),
//             ],
//           ),
//         ),
//       ]),
//     ]),
//   );
//   // return month;
// }
