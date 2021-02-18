import 'package:darky_app/models/mail.dart';
import 'package:darky_app/presentation/widgets/alert_dialog.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MailPage extends StatefulWidget {
  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "PASKASTE",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: Color(0xFF6DC0C4),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: 48.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Iesūtne",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xff7E8AA2),
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  StreamBuilder(
                                    builder: (context, snap) {
                                      if (snap.hasData &&
                                          snap.connectionState ==
                                              ConnectionState.active) {
                                        var mail =
                                            snap.data as List<MailMessage> ??
                                                List();

                                        return Container(
                                          height: 400,
                                          child: ListView.builder(
                                              itemCount: mail.length,
                                              itemBuilder: (context, i) {
                                                return _buildMessageContainer(
                                                    body: mail[i].body,
                                                    date: mail[i].date,
                                                    subject: mail[i].subject,
                                                    from: mail[i].from,
                                                    isMessageOpened:
                                                        mail[i].opened,
                                                    context: context);
                                              }),
                                        );
                                      }
                                      return Text("wait");
                                    },
                                    stream: context
                                        .read(databaseServiceProvider)
                                        .getMailContent(context
                                            .read(authenticationServiceProvider)
                                            .currentUserEmail),
                                  ),
                                  RaisedButton(
                                    onPressed: () {},
                                    child: Text("Test"),
                                    color: Colors.amber[200],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ]));
  }

  Widget _buildMessageContainer(
      //Consider to put "subject" somewhere
      {BuildContext context,
      bool isMessageOpened,
      String body,
      String from,
      String subject,
      String date}) {
    return ExpansionTile(
      onExpansionChanged: (expansionTileOpened) {
        //MARKS MESSAGE AS OPENED IT WILL REFLECT ON UNREAD MESSAGE INDICATOR
        if (expansionTileOpened) {
          if (isMessageOpened) {
            print("opened a while ago");
          } else {
            DatabaseService.setMailMessageAsOpened(
                email: context
                    .read(authenticationServiceProvider)
                    .currentUserEmail,
                date: date);
          }
        }
      },
      backgroundColor: Colors.white,
      trailing: Container(
        height: 45,
        width: 70,
        padding: EdgeInsets.zero,
        child: Text(from),
        color: isMessageOpened ? Colors.white : Colors.orange[200],
      ),
      title: Container(
          padding: EdgeInsets.only(top: 14, bottom: 14),
          color: isMessageOpened ? Colors.white : Colors.orange[200],
          child: Text(subject, textAlign: TextAlign.center)),
      children: [
        GestureDetector(
          onTap: () {},
          onLongPress: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => YesNoAlert(
                      content: "Are you sure u want to delete this message?",
                      title: "Caution",
                      onYes: () {
                        print("you pressed yes");
                        DatabaseService.deleteMailMessage(
                            date: date,
                            email: context
                                .read(authenticationServiceProvider)
                                .currentUserEmail);
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      onNo: () {
                        print("you pressed no");
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                    ));
          },
          child: new Container(
              height: 48.0,
              width: MediaQuery.of(context).size.width / 1.4,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Text(
                body,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
        )
      ],
    );
  }
}
