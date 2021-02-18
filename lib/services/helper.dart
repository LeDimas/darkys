import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'database_service.dart';

class Helper {
  Helper._privateConstructor();
  static final Helper _instance = Helper._privateConstructor();
  static Helper get instance => _instance;

  Stream provideMemberScheduleStream(
      {@required String role, @required List sections}) {
    Stream bboySchedStream;
    Stream hiphopSchedStream;
    Stream multiGroupSchedStream;
    Stream streamOfMySchedule;

    if (role != 'admin' && role != 'coach') {
      if (sections.contains('breaking_section')) {
        bboySchedStream = DatabaseService.getDefSched('breaking_section');
      }
      if (sections.contains('hiphop_section')) {
        hiphopSchedStream = DatabaseService.getDefSched('hiphop_section');
      }
      if (sections.contains('multi_group_section')) {
        multiGroupSchedStream =
            DatabaseService.getDefSched('multi_group_section');
      }
    } else {
      sections.add('breaking_section');
      sections.add('hiphop_section');
      sections.add('multi_group_section');
      bboySchedStream = DatabaseService.getDefSched('breaking_section');
      hiphopSchedStream = DatabaseService.getDefSched('hiphop_section');
      multiGroupSchedStream =
          DatabaseService.getDefSched('multi_group_section');
    }

    List<Stream> all = [
      bboySchedStream,
      hiphopSchedStream,
      multiGroupSchedStream
    ];

    all.removeWhere((element) => element == null);
    if (all.length == 0) print("netu");
    if (all.length == 1) {
      streamOfMySchedule = all.first;
    }
    //+++++++
    if (all.length == 2) {
      streamOfMySchedule =
          all[0].zipWith(all[1], (oneDoc, secDoc) => [oneDoc, secDoc]);
    }
    if (all.length == 3) {
      streamOfMySchedule = all[0]
          .zipWith(all[1], (t, s) => [t, s])
          .zipWith(all[2], (t, s) => [t, s]);
    }
    return streamOfMySchedule;
  }
}
