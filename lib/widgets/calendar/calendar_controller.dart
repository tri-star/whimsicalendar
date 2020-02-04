import 'package:flutter/cupertino.dart';

class CalendarController with ChangeNotifier {
  DateTime _selectedDate;

  CalendarController() : _selectedDate = null;

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;
}
