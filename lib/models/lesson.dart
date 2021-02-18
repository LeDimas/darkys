import 'package:time_range_picker/time_range_picker.dart';

class Lesson {
  final String day;
  final TimeRange time;
  final String section;
  Lesson({
    this.day,
    this.time,
    this.section,
  });
}

class DefaultLesson {
  final List<String> days;
  final String time;
  final String section;
  DefaultLesson({
    this.days,
    this.time,
    this.section,
  });
}
