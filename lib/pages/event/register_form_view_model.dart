import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';

class RegisterFormViewModel with ChangeNotifier {
  CalendarEvent _event;

  RegisterFormViewModel(DateTime currentDate) : _event = CalendarEvent() {
    _event.startDateTime = currentDate;
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
    if (newDate == null) {
      return;
    }
    _event.startDateTime = newDate;
    notifyListeners();
  }

  DateTime get endDate => _event.getEndDate();
  void set endDate(DateTime newDate) {
    if (newDate == null) {
      return;
    }
    _event.endDateTime = newDate;
    notifyListeners();
  }

  TimeOfDay get startTime {
    DateTime date = _event.startDateTime;
    if (date == null) {
      return null;
    }
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  void set startTime(TimeOfDay time) {
    if (time == null) {
      return;
    }
    _event.startDateTime = DateTime(
        _event.startDateTime.year,
        _event.startDateTime.month,
        _event.startDateTime.day,
        time.hour,
        time.minute,
        0);
    notifyListeners();
  }

  TimeOfDay get endTime {
    DateTime date = _event.endDateTime;
    if (date == null) {
      return null;
    }
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  void set endTime(TimeOfDay time) {
    _event.endDateTime = DateTime(
        _event.endDateTime.year,
        _event.endDateTime.month,
        _event.endDateTime.day,
        time.hour,
        time.minute,
        0);
    notifyListeners();
  }

  String formatDate(DateTime date) {
    if (date == null) {
      return '';
    }
    return DateFormat('y-MM-dd').format(date);
  }

  String formatTime(TimeOfDay time) {
    if (time == null) {
      return '';
    }
    NumberFormat timeFormat = NumberFormat('00');
    return '${timeFormat.format(time.hour)}:${timeFormat.format(time.minute)}';
  }
}
