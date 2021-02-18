import 'package:darky_app/models/member.dart';
import 'package:darky_app/presentation/ui/admin/member_tile.dart';

import 'package:flutter/material.dart';
import 'package:darky_app/services/database_service.dart';

class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  List<Member> members = List<Member>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF6DC0C4),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "All",
                ),
                Tab(
                  text: "Breaking",
                ),
                Tab(
                  text: "Hip-Hop",
                ),
                Tab(text: "MultiGroup")
              ],
            ),
            title: Text(
              "Pilnais cilvēku saraksts",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              memberListTabView(),
              memberListTabView('breaking_section'),
              memberListTabView('hiphop_section'),
              memberListTabView('multi_group_section'),
            ],
          )),
    );
  }

  Widget getListView([String section]) {
    var widget = FutureBuilder(
        future: DatabaseService.memberOfSection(section),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            members = snapshot.data;

            return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return MemberTile(member: members[index]);
                });
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

    return widget;
  }

  Widget memberListTabView([String section]) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(color: Color(0xFF263248)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
        child: Container(
            decoration: BoxDecoration(
                color: Color(0xff7E8AA2),
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            height: MediaQuery.of(context).size.height / 1.5,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: getListView(section),
            )),
      ),
    );
  }

  // Consumer(
  //   builder: (context, watch, child) {
  //     var stream = watch(databaseServiceProvider).members;

  //     stream.listen((data) {
  //       setState(() {
  //         members = data;
  //       });
  //     });

  //     return

  // var listView = ListView(
  //   children: [
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Text(
  //           "Edit",
  //           style: TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(top: 16, bottom: 16),
  //           child: IconButton(
  //               icon: Icon(
  //                 Icons.edit,
  //                 color: Colors.white,
  //               ),
  //               onPressed: () {
  //                 print("You pressed edit this list");
  //               }),
  //         ),
  //       ],
  //     ),
  //     InkWell(
  //       onTap: () {
  //         Navigator.push(
  //             context,
  //             new MaterialPageRoute(
  //                 builder: (context) => MemberProfilePage()));
  //       },
  //       child: Container(
  //         padding: EdgeInsets.all(16.0),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //         child: Text("Vārds, Uzvārds"),
  //       ),
  //     ),
  //     SizedBox(
  //       height: 8,
  //     ),
  //     SizedBox(
  //       height: 8,
  //     ),
  //   ],
  // );

  // return listView;

}
