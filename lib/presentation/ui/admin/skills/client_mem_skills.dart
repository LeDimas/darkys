import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:darky_app/models/consts.dart';
import 'package:darky_app/presentation/ui/admin/skills/certain_skills.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/providers.dart';

class ClientMemberSkill extends StatefulWidget {
  final String role;
  final dynamic sections;
  ClientMemberSkill({
    Key key,
    this.role,
    this.sections,
  }) : super(key: key);

  @override
  _ClientMemberSkillState createState() => _ClientMemberSkillState();
}

class _ClientMemberSkillState extends State<ClientMemberSkill> {
  @override
  void initState() {
    sectionFilter = widget.sections.first;
    super.initState();
  }

  dynamic sectionFilter;
  @override
  Widget build(BuildContext context) {
    print(sectionFilter.runtimeType);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6DC0C4),
          title: Text("Manage members skills"),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0, bottom: 50),
                  child: Container(
                      child: StreamBuilder<Object>(
                          stream: DatabaseService.getMemberSectionsStream(
                              context
                                  .read(authenticationServiceProvider)
                                  .currentUserEmail),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              var sections = snapshot.data as List;

                              return Column(children: [
                                Container(
                                  height: 20,
                                  padding: EdgeInsets.only(
                                      left: (sections.length / 0.05)),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, i) {
                                      return RaisedButton(
                                        onPressed: () {
                                          setState(() {
                                            sectionFilter = sections[i];
                                          });
                                        },
                                        color: Colors.cyan,
                                        child: Text(
                                            btnSectionFilterMap[sections[i]]),
                                      );
                                    },
                                    itemCount: sections.length,
                                  ),
                                )
                              ]);
                            }
                            return SizedBox(
                              height: 100,
                              width: 100,
                            );
                          })),
                ),
                sectionFilter == 'multi_group_section'
                    ? Text('multigroup')
                    : StreamBuilder(
                        stream: DatabaseService.getMemberProgress3(
                            email: context
                                .read(authenticationServiceProvider)
                                .currentUserEmail,
                            section: sectionFilter),
                        builder: (_, snap) {
                          if (snap.hasData &&
                              snap.connectionState == ConnectionState.active) {
                            var dataBundle = snap.data as List;
                            print(dataBundle);

                            var memMoves = dataBundle.first as List<Map>;
                            Set<int> temp = Set();
                            var sectionTypes = dataBundle[1];
                            var memtier = dataBundle.last;
                            var allMoves = dataBundle[2] as List<Map>;
                            for (var i = 0; i < allMoves.length; i++) {
                              if (memMoves.any((memMove) =>
                                  memMove['name'] == allMoves[i]['moveName'])) {
                                allMoves[i]['progress'] = memMoves.firstWhere(
                                    (move) =>
                                        move['name'] ==
                                        allMoves[i]['moveName'])['progress'];

                                allMoves[i]['learned'] = memMoves.firstWhere(
                                        (move) =>
                                            move['name'] ==
                                            allMoves[i]['moveName'])['learned']
                                    //; ?? 'locked
                                    ;
                              }
                              temp.add(int.tryParse(allMoves[i]['moveTier']));
                              //else{allMoves[i]['progress'] = 'locked' ; allMoves[i]['learned'] = 'locked'}
                            }

                            var tierList = temp.toList()
                              ..sort((a, b) => a.compareTo(b));
                            print(tierList);

                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (_, tier) {
                                    return Column(
                                      children: [
                                        Text(
                                          "tier ${tierList[tier].toString()}",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.yellow),
                                        ),
                                        tier <= memtier
                                            ? GridView.builder(
                                                shrinkWrap: true,
                                                itemCount: sectionTypes.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                        maxCrossAxisExtent: 170,
                                                        childAspectRatio: 7 / 6,
                                                        crossAxisSpacing: 20,
                                                        mainAxisSpacing: 20),
                                                itemBuilder: (_, i) {
                                                  var total = allMoves
                                                      .where((move) =>
                                                          int.tryParse(move[
                                                                  'moveTier']) ==
                                                              tier &&
                                                          move['moveType'] ==
                                                              sectionTypes[i])
                                                      .length;
                                                  var learned = allMoves
                                                      .where((move) =>
                                                          int.tryParse(move[
                                                                  'moveTier']) ==
                                                              tier &&
                                                          move['moveType'] ==
                                                              sectionTypes[i] &&
                                                          move['learned'] ==
                                                              true &&
                                                          move['moveType'] ==
                                                              sectionTypes[i])
                                                      .length;

                                                  var parsedTotal =
                                                      double.parse(
                                                          total.toString());
                                                  var parsedLearned =
                                                      double.parse(
                                                          learned.toString());
                                                  return InkWell(
                                                      onDoubleTap: () {
                                                        var movesToPutInCollection = allMoves
                                                            .where((move) =>
                                                                move['moveType'] ==
                                                                    sectionTypes[
                                                                        i] &&
                                                                int.tryParse(move[
                                                                        'moveTier']) ==
                                                                    tier)
                                                            .toList();

                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (context) => CertainSkills(
                                                                    role: widget
                                                                        .role,
                                                                    tier: tier,
                                                                    moves:
                                                                        movesToPutInCollection,
                                                                    email: context
                                                                        .read(
                                                                            authenticationServiceProvider)
                                                                        .currentUserEmail,
                                                                    section:
                                                                        sectionFilter)));
                                                      },
                                                      child: _discipline(
                                                          name: sectionTypes[i],
                                                          progress:
                                                              parsedLearned,
                                                          max: parsedTotal)
                                                      // Container(
                                                      //   alignment: Alignment.center,
                                                      //   child: Column(
                                                      //     children: [
                                                      //       Text(sectionTypes[i])
                                                      //     ],
                                                      //   ),
                                                      //   decoration: BoxDecoration(
                                                      //       color: Colors.amber,
                                                      //       borderRadius:
                                                      //           BorderRadius.circular(
                                                      //               15)),
                                                      // ),

                                                      );
                                                })
                                            : GridView.builder(
                                                shrinkWrap: true,
                                                itemCount: sectionTypes.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                        maxCrossAxisExtent: 170,
                                                        childAspectRatio: 7 / 6,
                                                        crossAxisSpacing: 20,
                                                        mainAxisSpacing: 20),
                                                itemBuilder: (_, i) {
                                                  return _lockedDiscipline(
                                                      name: sectionTypes[i]);
                                                },
                                              ),
                                        SizedBox(
                                          height: 150,
                                        )
                                      ],
                                    );
                                  },
                                  itemCount: tierList.length,
                                ));
                          }

                          return SizedBox(
                            height: 300,
                            width: 300,
                          );
                        })
              ],
            ),
          )
        ]));
  }
}

Widget _lockedDiscipline({String name}) {
  return InkWell(
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          SizedBox(
            height: 8.0,
          ),
          Expanded(
              flex: 1,
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              )),
          Flexible(
              flex: 3,
              child: Icon(
                Icons.lock_outlined,
                color: Colors.yellow,
                size: 96,
              ))
        ],
      ),
    ),
  );
}

Widget _discipline({String name, double progress, double max}) {
  double progressValue = progress;
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Column(
      children: [
        SizedBox(
          height: 8.0,
        ),
        Expanded(
            flex: 1,
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            )),
        Expanded(
          flex: 3,
          child: SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: max < 1 ? 5 : max,
              showLabels: false,
              showTicks: false,
              axisLineStyle: AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: progressValue,
                  cornerStyle: CornerStyle.bothCurve,
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.1,
                  angle: 90,
                  widget: Text(
                    progressValue.toString() + ' /' + max.toString(),
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ],
    ),
  );
}
