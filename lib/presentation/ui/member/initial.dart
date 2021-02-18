import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:darky_app/models/member.dart';
import 'package:darky_app/presentation/ui/admin/calendar.dart';
import 'package:darky_app/presentation/ui/admin/skills/client_mem_skills.dart';

import 'package:darky_app/presentation/ui/admin/video/member_list.dart';
import 'package:darky_app/presentation/ui/member/feed.dart';
import 'package:darky_app/presentation/ui/member/home.dart';

import 'package:darky_app/presentation/ui/member/tutorial.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/providers.dart';

class InitialWidget extends StatefulWidget {
  final String role;
  final Member mem;
  InitialWidget({
    Key key,
    this.role,
    this.mem,
  }) : super(key: key);

  @override
  _InitialWidgetState createState() => _InitialWidgetState(role);
}

class _InitialWidgetState extends State<InitialWidget> {
  String role;
  bool isBillingGenerated = true;
  int currentTab = 0;
  HomePage home;
  NewsFeedPage feed;
  ClientMemberSkill skillTree;
  dynamic tutorPage;
  MemberListPage memberList;
  CalendarPage calendar;
  List<Widget> pages;
  Widget currentPage;
  List<BottomNavigationBarItem> items;
  int day;
  _InitialWidgetState(this.role);
  List sections;
  bool gotSections = false;

  @override
  void initState() {
    feed = NewsFeedPage();
    skillTree = ClientMemberSkill(
      role: widget.role,
      sections: [...widget.mem.section],
    );
    home = HomePage(
      role: role,
    );

    tutorPage = TutorialPage(
      role: role,
    );
    memberList = MemberListPage();
    calendar = CalendarPage();

    day = DateTime.now().day;
    currentPage = home;

    context.read(fcmProvider).setupFirebase(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setNavBar();
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: items,
      ),
    );
  }

  setNavBar() {
    if (role == "member") {
      pages = [home, feed, skillTree, tutorPage];
      items = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
          backgroundColor: Color(0xFF7E8AA2),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: "News",
          backgroundColor: Color(0xFF7E8AA2),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gamepad),
          label: "Stats",
          backgroundColor: Color(0xFF7E8AA2),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_collection),
          label: "Tutorials",
          backgroundColor: Color(0xFF7E8AA2),
        )
      ];
    }
    if (role == 'admin' || role == 'coach') {
      //not best way,maybe even the worst one
      bool monthGenerated = false;

      if (day == 25) {
        context
            .read(checkingProvider)
            .monthBillingsGenerated()
            .then((value) => monthGenerated);
        if (!monthGenerated) {
          DatabaseService.generateMonthBills();
        }
      }

      pages = [home, feed, tutorPage, memberList, calendar];
      items = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Profile",
          backgroundColor: Color(0xFF7E8AA2),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: "News",
          backgroundColor: Color(0xFF7E8AA2),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_collection),
          label: "Tutorials",
          backgroundColor: Color(0xFF7E8AA2),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Saraksts",
          backgroundColor: Color(0xFF7E8AA2),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: "Kalendārs",
          backgroundColor: Color(0xFF7E8AA2),
        ),
      ];
    }
  }
}
