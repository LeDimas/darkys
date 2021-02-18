import 'package:darky_app/models/member.dart';
import 'package:darky_app/presentation/ui/admin/payment/profile.dart';
import 'package:darky_app/presentation/widgets/alert_dialog.dart';
import 'package:darky_app/services/database_service.dart';

import 'package:flutter/material.dart';

class MemberTile extends StatefulWidget {
  const MemberTile({Key key, this.member}) : super(key: key);
  final Member member;

  @override
  _MemberTileState createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  bool isTodayBreaking = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: GestureDetector(
        onLongPress: () {
          Navigator.of(context).push(_createRoute(widget.member));
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.member.avatarUrl),
              backgroundColor: Colors.deepOrange,
            ),
            title: Text(widget.member.name),
            subtitle: Text(widget.member.section.first),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.red[900],
              ),
              onTap: () async {
                showDialog(
                    context: (context),
                    builder: (_) => YesNoAlert(
                          content:
                              'Are you sure you want to delete this member?',
                          title: 'Warning',
                          onNo: () {
                            Navigator.pop(context);
                          },
                          onYes: () {
                            DatabaseService.deleteMember(widget.member.email);
                            Navigator.pop(context);
                            Future.delayed(Duration(seconds: 3), () {
                              setState(() {});
                            });
                          },
                        ));
              },
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Member member) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MemberProfilePage(
            member: member,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}
