import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';

class RegisterFormViewModel with ChangeNotifier {
  CalendarEvent _event;

  RegisterFormViewModel(DateTime currentDate) : _event = CalendarEvent() {
    _event.setStartDate(currentDate);
  }

  String get name => _event.name;
  set name(String newName) {
    _event.name = newName;
    notifyListeners();
  }

  bool get isAllDay => _event.isAllDay;
  void set isAllDay(bool value) {
    _event.isAllDay = value;
    notifyListeners();
  }

  DateTime get startDate => _event.getStartDate();
  void set startDate(DateTime newDate) {
    _event.setStartDate(newDate);
    notifyListeners();
  }

  String formatDate(DateTime date) {
    if (date == null) {
      return '';
    }
    return DateFormat('y-MM-dd').format(date);
  }
}
