import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darky_app/services/database_service.dart';

class CheckService {
  Map<String, int> dateLookup = {
    "Monday": 1,
    "Tuesday": 2,
    "Wednesday": 3,
    "Thursday": 4,
    "Friday": 5,
    "Saturday": 6,
    "Sunday": 7
  };

  static Future checkPeople(List<String> whoWas, List<String> whoWasnt) async {
    whoWas.forEach((email) async {
      await DatabaseService.setAttendance(email, DateTime.now(), true);
      await DatabaseService.incereaseXP(email);
      whoWasnt.forEach((email) async {
        DatabaseService.setAttendance(email, DateTime.now(), false);
      });
    });
  }

  static Future<bool> hasPayed(int month, String email,
      {bool monthPay = true}) async {
    // var snap = await DatabaseService.getBillings(month, email);

    var hasPayedOrNot = false;
    // snap.docs.first.data()["Payed"] as bool;

    return hasPayedOrNot ?? false;
  }

  static Future<bool> haveToPay(
    int month,
    String email,
  ) async {
    var snap = await DatabaseService.getBillings(month, email);
    if (snap.size > 0) {
      return true;
    }
    if (snap.size < 1) {
      return false;
    }
    return false;
  }

  static Stream get isTodayListCheckedStream {
    return FirebaseFirestore.instance
        .collection('lessons')
        .doc('checkedToday')
        .snapshots();
  }

  static Future<void> fixMultiGroupTodayCheckList() async {
    await FirebaseFirestore.instance
        .collection('lessons')
        .doc('checkedToday')
        .update({"multi_group": DateTime.now()});
  }

  static Future<void> fixHipHopTodayCheckList() async {
    await FirebaseFirestore.instance
        .collection('lessons')
        .doc('checkedToday')
        .update({"hiphop": DateTime.now()});
  }

  static Future<void> fixBreakingTodayCheckList() async {
    await FirebaseFirestore.instance
        .collection('lessons')
        .doc('checkedToday')
        .update({"breaking": DateTime.now()});
  }

  Future<bool> monthBillingsGenerated() async {
    var resp = await FirebaseFirestore.instance
        .collection("payment")
        .doc(DateTime.now().month.toString())
        .get();
    return resp.data()['generated'] as bool;
  }

  Future<bool> get isTodayBreaking async {
    var defSched = await DatabaseService.getDefaultSchedule('breaking_section');
    var today = DateTime.now().weekday;
    var classesDays = defSched['Days'] as List;
    return classesDays.any((day) => dateLookup[day] == today);
  }

  Future<bool> get isTodayMultiGroup async {
    var defSched =
        await DatabaseService.getDefaultSchedule('multi_group_section');
    var today = DateTime.now().weekday;
    var classesDays = defSched['Days'] as List;
    return classesDays.any((day) => dateLookup[day] == today);
  }

  Future<bool> get isTodayHipHop async {
    var defSched = await DatabaseService.getDefaultSchedule('hiphop_section');
    var today = DateTime.now().weekday;
    var classesDays = defSched['Days'] as List;

    return classesDays.any((day) => dateLookup[day] == today);
  }
}
