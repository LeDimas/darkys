import 'package:flutter/material.dart';

import 'package:darky_app/services/database_service.dart';

class CertainSkills extends StatefulWidget {
  CertainSkills({
    Key key,
    this.moves,
    this.tier,
    this.role,
    this.email,
    this.section,
  }) : super(key: key);
  final List<Map<String, dynamic>> moves;
  final int tier;
  final String role;
  final String email;
  final String section;
  @override
  _CertainSkillsState createState() => _CertainSkillsState();
}

class _CertainSkillsState extends State<CertainSkills> {
  Map<String, dynamic> progressMapNameProgress = {};
  Map<String, bool> learnedMapNameLearned = {};
  bool changesMade = false;

  @override
  void initState() {
    if (widget.role != 'member') {
      widget.moves.forEach((move) {
        progressMapNameProgress['${move['moveName']}'] =
            // ignore: unnecessary_cast
            move['progress'];
        learnedMapNameLearned['${move['moveName']}'] = move['learned'];
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role != 'member') {
      if (widget.moves.every((e) =>
          e['progress'] == progressMapNameProgress['${e['moveName']}'] &&
          e['learned'] == learnedMapNameLearned['${e['moveName']}']))
        changesMade = false;
      else
        changesMade = true;
    }

    return Scaffold(
        floatingActionButton: !changesMade
            ? null
            : FloatingActionButton(
                onPressed: () {
                  DatabaseService.updateSkills(
                      tier: widget.tier,
                      email: widget.email,
                      section: widget.section,
                      learnedMap: learnedMapNameLearned,
                      progressMap: progressMapNameProgress);
                },
                child: Icon(
                  Icons.auto_fix_high,
                  color: Colors.red,
                ),
              ),
        appBar: AppBar(
          backgroundColor: Color(0xFF6DC0C4),
          title: Text("Manage members skills"),
        ),
        body: Column(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.8944,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
            child: Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 60),
                child: ListView.builder(
                  itemBuilder: (_, i) {
                    return Container(
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: learnedMapNameLearned[
                                          '${widget.moves[i]['moveName']}'] ==
                                      false
                                  ? Text(
                                      widget.moves[i]['moveName'],
                                      style: TextStyle(fontSize: 35),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(widget.moves[i]['moveName'],
                                              style: TextStyle(fontSize: 35)),
                                          Text(
                                            "LEARNED!",
                                            style: TextStyle(
                                                fontSize: 35,
                                                backgroundColor: Colors.yellow),
                                          )
                                        ],
                                      ),
                                    )),
                          LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: learnedMapNameLearned[
                                        '${widget.moves[i]['moveName']}'] ==
                                    false
                                ? AlwaysStoppedAnimation<Color>(Colors.green)
                                : AlwaysStoppedAnimation<Color>(Colors.purple),
                            value: progressMapNameProgress[
                                    '${widget.moves[i]['moveName']}'] *
                                0.01,
                          ),
                          widget.role != 'member'
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_circle_up,
                                            size: 40,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            print("ok");
                                            if (progressMapNameProgress[
                                                    '${widget.moves[i]['moveName']}'] <
                                                100) {
                                              setState(() {
                                                progressMapNameProgress[
                                                        '${widget.moves[i]['moveName']}'] =
                                                    progressMapNameProgress[
                                                            '${widget.moves[i]['moveName']}'] +
                                                        20;
                                                if (progressMapNameProgress[
                                                        '${widget.moves[i]['moveName']}'] ==
                                                    100) {
                                                  learnedMapNameLearned[
                                                          '${widget.moves[i]['moveName']}'] =
                                                      true;
                                                }
                                              });
                                            }
                                          }),
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_circle_down,
                                            size: 40,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            if (progressMapNameProgress[
                                                    '${widget.moves[i]['moveName']}'] >
                                                0) {
                                              setState(() {
                                                progressMapNameProgress[
                                                        '${widget.moves[i]['moveName']}'] =
                                                    progressMapNameProgress[
                                                            '${widget.moves[i]['moveName']}'] -
                                                        20;

                                                learnedMapNameLearned[
                                                        '${widget.moves[i]['moveName']}'] =
                                                    false;
                                              });
                                            }
                                          }),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 120),
                                        child: IconButton(
                                          icon: Icon(
                                            learnedMapNameLearned[
                                                        '${widget.moves[i]['moveName']}'] ==
                                                    false
                                                ? Icons
                                                    .check_circle_outline_sharp
                                                : Icons.check_circle,
                                            size: 40,
                                            color: learnedMapNameLearned[
                                                        '${widget.moves[i]['moveName']}'] ==
                                                    false
                                                ? Colors.blueGrey
                                                : Colors.green,
                                          ),
                                          onPressed: () {
                                            if (progressMapNameProgress[
                                                    '${widget.moves[i]['moveName']}'] !=
                                                100) {
                                              setState(() {
                                                learnedMapNameLearned[
                                                        '${widget.moves[i]['moveName']}'] =
                                                    true;
                                                progressMapNameProgress[
                                                        '${widget.moves[i]['moveName']}'] =
                                                    100;
                                              });
                                            } else {
                                              setState(() {
                                                learnedMapNameLearned[
                                                        '${widget.moves[i]['moveName']}'] =
                                                    false;
                                                progressMapNameProgress[
                                                    '${widget.moves[i]['moveName']}'] = 0;
                                              });
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 40,
                                )
                        ],
                      ),
                    );
                  },
                  itemCount: widget.moves.length,
                ),
              ),
            ),
          ),
        ]));
  }
}
