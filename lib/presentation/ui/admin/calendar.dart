import 'package:darky_app/services/database_service.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

// ignore: camel_case_types
class _CalendarPageState extends State<CalendarPage> {
  CalendarController _controller;
  List<bool> values = List.filled(7, false);
  Map<String, IconData> sectionIconMap = {
    "Breaking": Icons.directions_run,
    "Hip-hop": Icons.local_fire_department,
    "Multi-Group": Icons.tag_faces
  };
  TimeRange pickedTime =
      TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now());

  String start;
  String end;
  String dropdownValue = "Breaking";
  bool isPicked = false;

  @override
  void initState() {
    super.initState();

    start = pickedTime.startTime.hour.toString() +
        ":" +
        pickedTime.startTime.minute.toString();
    end = pickedTime.endTime.hour.toString() +
        ":" +
        pickedTime.endTime.minute.toString();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF6DC0C4),
          title: Text(
            "Calendar",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF263248),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      children: [
                        TableCalendar(
                          calendarStyle: CalendarStyle(
                            todayColor: Color(0xff263248),
                            selectedColor: Color(0xFF6DC0C4),
                          ),
                          weekendDays: [2, 4],
                          headerStyle: HeaderStyle(
                            decoration: BoxDecoration(
                                color: Color(0xFF3EA4A9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            headerMargin: const EdgeInsets.only(bottom: 16.0),
                            centerHeaderTitle: true,
                            formatButtonDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            formatButtonShowsNext: false,
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(color: Colors.white),
                              decoration: BoxDecoration()),
                          builders: const CalendarBuilders(),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarController: _controller,
                        )
                      ],
                      title: Padding(
                        padding: const EdgeInsets.only(left: 150),
                        child: Text(
                          "Calendar",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ExpansionTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Text("Schedule settings"),
                      ),
                      children: [
                        _weekdayPicker(context),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Icon(sectionIconMap[dropdownValue])),
                            DropdownButton<String>(
                              value: dropdownValue,
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: sectionIconMap.keys
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Icon(Icons.query_builder),
                            ),
                            _lessonTimePicker(context),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        //Schedule setup bar
                        //Set up for this week
                        Row(
                          children: [
                            //Set as default
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: InkWell(
                                onTap: () {
                                  // print(
                                  //     "dont forget to make here data validation to evade any exceptions");
                                  DatabaseService.setDefaultSchedule(
                                      days: values,
                                      beginOfLesson: pickedTime.startTime,
                                      endOfLesson: pickedTime.endTime,
                                      section: dropdownValue);
                                  // print(DateTime.monday);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Text(
                                    "Set as default", //set as default
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        )
                      ],
                      initiallyExpanded: true, //kak udobno
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Center(
                      child: Text(
                        "Informācija",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.red,
                          ),
                          Text(
                            "Treniņu dienas",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.black,
                          ),
                          Text(
                            "Parastas dienas",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.white,
                          ),
                          Text(
                            "Šodiena",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]));
  }

  _weekdayPicker(BuildContext context) {
    return WeekdaySelector(
        onChanged: (int day) {
          setState(() {
            final index = day % 7;
            values[index] = !values[index];
          });
        },
        values: values);
  }

  _lessonTimePicker(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          var pckdTime = await showTimeRangePicker(
              context: context,
              start: TimeOfDay(
                  hour: pickedTime.startTime.hour,
                  minute: pickedTime.startTime.minute),
              end: TimeOfDay(
                  hour: pickedTime.endTime.hour,
                  minute: pickedTime.endTime.minute),
              use24HourFormat: true);
          pickedTime = pckdTime ?? pickedTime;
          setState(() {
            isPicked = true;
            start = pickedTime.startTime.hour.toString() +
                ":" +
                pickedTime.startTime.minute.toString();
            end = pickedTime.endTime.hour.toString() +
                ":" +
                pickedTime.endTime.minute.toString();
          });
        },
        child: Text(
          isPicked ? "From: $start to $end" : "Pick the time",
          style: TextStyle(color: Colors.red, fontSize: 15),
        ));
  }
}

//Below is code for single classes scheduling

// Padding(
//   padding: const EdgeInsets.only(left: 25),
//   child: InkWell(
//     onTap: () {},
//     child: Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//           color: Color(0xFF6DC0C4),
//           borderRadius:
//               BorderRadius.all(Radius.circular(8))),
//       child: Text(
//         "this week",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16.0,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ),
// ),
// Padding(
//   padding:
//       const EdgeInsets.symmetric(horizontal: 10),
//   child: InkWell(
//     onTap: () {},
//     child: Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//           color: Color(0xFF6DC0C4),
//           borderRadius:
//               BorderRadius.all(Radius.circular(8))),
//       child: Text(
//         "next week",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16.0,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ),
// )
