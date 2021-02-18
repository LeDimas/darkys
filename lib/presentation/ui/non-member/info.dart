import 'package:darky_app/presentation/ui/non-member/payment_rules.dart';
import 'package:darky_app/presentation/ui/non-member/rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF263248),
        ),
      ),
      Flexible(
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 48.0, left: 16, right: 16),
                        child: new Image.asset(
                            "lib/assets/2020_darky_app_flutter_logo.png"),
                      ),
                    ),
                    Text(
                      "DEJU TRUPAS",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24.0, left: 16, right: 16),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 150,
                                width: 120,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    color: Color(0xFF6DC0C4),
                                    width: 96,
                                    height: 96,
                                    child: FlatButton(
                                      onPressed: () {},
                                      child: Text("dinah"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  color: Color(0xFFD93731),
                                  width: 96,
                                  height: 96,
                                  child: FlatButton(
                                    onPressed: () {},
                                    child: Text("dinah"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  color: Color(0xFFF7EB7D),
                                  width: 96,
                                  height: 96,
                                  child: FlatButton(
                                    onPressed: () {},
                                    child: Text("dinah"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(),
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 96,
                                  height: 80,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Breaking",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 96,
                                height: 80,
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Hip-Hop",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 96,
                                height: 80,
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Mixed",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 48.0, left: 16, right: 16),
                      child: Text(
                        "NODARBĪBU SARAKSTS",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 48.0, top: 48.0, left: 16, right: 16),
                        child: new Image.asset(
                            "lib/assets/2020_darky_nodarbibu_ver2.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Text(
                        "IZCENOJUMS",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 48.0),
                        child: new Image.asset("lib/assets/zoom2.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Pirmā nodarbība bezmaksas",
                        style: TextStyle(
                          color: Color(0xFFF7EB7D),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "*ja pie mums iepriekš vēl neesi dejojis",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 64.0),
                        child: new Image.asset("lib/assets/money.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "30 EUR / MĒN",
                        style: TextStyle(
                          color: Color(0xFFF7EB7D),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "*par viena deju stila apmeklējumu",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 64.0),
                        child: new Image.asset("lib/assets/home.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Liepājas Olimpiskais Centrs",
                        style: TextStyle(
                          color: Color(0xFFF7EB7D),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: Text(
                          "Brīvības iela 39,Liepāja\n Rožu zālē (1.stāvā). Ieeja gar sānu",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 80.0, left: 16, right: 16),
                      child: Container(
                        height: 124,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Color(0xFF6DC0C4),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        child: FlatButton(
                          child: Text(
                            "Apmaksas nosacījumi un pieejamās atlaides",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => PaymentRulesPage()));
                          }, //TODO make design
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 32.0, left: 16, right: 16),
                      child: Container(
                        height: 124,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Color(0xFF6DC0C4),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        child: FlatButton(
                          child: Text(
                            "Iekšējie kārtības noteikumi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => RulesPage()));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 64.0, bottom: 32.0),
                      child: Text(
                        "GALERIJA",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Container(
                        height: 128,
                        width: 800,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 0, right: 0),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Container(
                                  height: 128,
                                  width: 128,
                                  child: Image.asset(
                                    "lib/assets/t1.jpg",
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            })),
                    Container(
                        height: 128,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 0, right: 0),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Container(
                                  height: 128,
                                  width: 128,
                                  child: Image.asset(
                                    "lib/assets/t1.jpg",
                                    fit: BoxFit.contain,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            })),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Text(
                        "Darky's Apģērbs",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Container(
                        height: 188,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 24, right: 6),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 188,
                                  width: 256,
                                  child: Image.asset(
                                    "lib/assets/t1.jpg",
                                    fit: BoxFit.fitWidth,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () {},
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 88.0),
                      child: Text(
                        "Sazinies ar mums",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "+371 267-41-768",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 48.0, left: 16, right: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Vārds",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              height: 64.0,
                              child: TextField(
                                keyboardType: TextInputType.name,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.blueAccent,
                                  ),
                                  hintText: "Ievadiet savu vārdu",
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              height: 64.0,
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.blueAccent,
                                  ),
                                  hintText: "Enter your e-mail",
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Ziņas tēma",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              height: 64.0,
                              child: TextField(
                                keyboardType: TextInputType.name,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon(
                                    Icons.message_sharp,
                                    color: Colors.blueAccent,
                                  ),
                                  hintText: "Ievadiet ziņas tēmu",
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Ziņa",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              alignment: Alignment.topLeft,
                              height: 128.0,
                              child: TextField(
                                keyboardType: TextInputType.name,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon(
                                    Icons.message_sharp,
                                    color: Colors.blueAccent,
                                  ),
                                  hintText: "Ievadiet ziņu",
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xFF6DC0C4),
                        ),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Sūtīt",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    ]));
  }
}
