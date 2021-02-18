import 'package:darky_app/models/member.dart';
import 'package:darky_app/presentation/ui/admin/check/breaking_list.dart';
import 'package:darky_app/presentation/ui/admin/check/multigroup.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'hip_hop_list.dart';
import 'package:darky_app/services/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePage extends StatefulWidget {
  @override
  _DatePageState createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  var isTodayLesson = false;

  List<Member> members;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService.memberOfSection(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done && snap.hasData) {
            members = snap.data;
            return _bodyWrapper();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Deju Grupas"),
              centerTitle: true,
              backgroundColor: Color(0xFF6DC0C4),
            ),
            body: Container(
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    "LOADING SCREENHOLDER",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                )),
          );
        });
  }

  _bodyWrapper() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Deju Grupas"),
          centerTitle: true,
          backgroundColor: Color(0xFF6DC0C4),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff7E8AA2),
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [chekingPanel()],
                ),
              ),
            ),
          ),
        ]));
  }

  chekingPanel() {
    return (Column(
      children: [
        SizedBox(
          height: 32,
        ),
        Text(
          "Deju grupas",
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          height: 32.0,
        ),
        _breakingCheckPanel(context),
        SizedBox(
          height: 16,
        ),
        _hiphopCheckPanel(context),
        SizedBox(
          height: 16,
        ),
        _multiGroupCheckPanel(context),
        SizedBox(
          height: 16,
        ),
      ],
    ));
  }

  _hiphopCheckPanel(BuildContext context) {
    return FutureBuilder(
        future: context.read(checkingProvider).isTodayHipHop,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data as bool == true) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => HipHopListPage(members)));
                  },
                  child: _panelTemplate(context, "HipHop"));
            } else {
              //make something if today is no
              return InkWell(
                  onTap: () {
                    print("nope");
                  },
                  child: _panelTemplate(context, "idi nahuy"));
            }
          }

          return Container(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              "LOADING SCREENHOLDER",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ));
        });
  }

  _breakingCheckPanel(BuildContext context) {
    return FutureBuilder(
        future: context.read(checkingProvider).isTodayBreaking,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data as bool == true) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => BreakingListPage(members)));
                  },
                  child: _panelTemplate(context, "Breaking"));
            } else {
              //make something if today is no
              return InkWell(
                  onTap: () {
                    print("nope");
                  },
                  child: _panelTemplate(context, "idi nahuy"));
            }
          }
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              "LOADING SCREENHOLDER",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ));
        });
  }

  _multiGroupCheckPanel(BuildContext context) {
    return FutureBuilder(
        future: context.read(checkingProvider).isTodayMultiGroup,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data as bool == true) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => MultiGroupListPage(
                                  members: members,
                                )));
                  },
                  child: _panelTemplate(context, "Multi Group"));
            } else {
              //make something if today is no
              return InkWell(
                  onTap: () {
                    print("nope");
                  },
                  child: _panelTemplate(context, "idi nahuy"));
            }
          }
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              "LOADING SCREENHOLDER",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ));
        });
  }
}

Widget _panelTemplate(BuildContext context, String panelMessage) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.2,
    height: 128,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
    child: Center(
      child: Text(
        panelMessage,
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
    ),
  );
}
