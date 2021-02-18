import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String argument;
  const PaymentPage({Key key, this.argument}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Maksajumu lapa"),
          centerTitle: true,
          shadowColor: Colors.transparent,
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
              padding: EdgeInsets.symmetric(vertical: 48.0, horizontal: 16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff7E8AA2),
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              // DISPLAYS The Month
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFEFEFE),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Novembris",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                              // DISPLAYS the week
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 4.0,
                                            bottom: 4.0,
                                            left: 8.0,
                                            right: 8.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffF7EB7D),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Text("01.11.2020 - 07.11.2020"),
                                      ),
                                      SizedBox(
                                        height: 32.0,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(16.0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.4,
                                        decoration: BoxDecoration(
                                            color: Color(0xffFEFEFE),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16.0))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "02.11.2020\n(Otrdiena)",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8.0,
                                                ),
                                                Icon(
                                                  Icons.check_box,
                                                  color: Color(0xFF6DC0C4),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 16.0,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "04.11.2020\n(Ceturtdiena)",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8.0,
                                                ),
                                                Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: Color(0xFF6DC0C4),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
