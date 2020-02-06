import 'package:flutter/cupertino.dart';

class CalendarController with ChangeNotifier {
  int scrollDirection;

  DateTime _currentMonth;
  DateTime _selectedDate;

  CalendarController()
      : _currentMonth = null,
        _selectedDate = null {
    if (_currentMonth == null) {
      _currentMonth = DateTime.now();
    }
  }

  set currentMonth(DateTime date) {
    _currentMonth = date;
    notifyListeners();
  }

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  DateTime get currentMonth => _currentMonth;
  DateTime get selectedDate => _selectedDate;

  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    scrollDirection = -1;
    notifyListeners();
  }

  void goToPrevMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    scrollDirection = 1;
    notifyListeners();
  }

  bool isNextMonthKey(ValueKey key) {
    DateTime nextMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    return ValueKey(nextMonth) == key;
  }

  bool isPrevMonthKey(ValueKey key) {
    DateTime prevMonth =
        DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    return ValueKey(prevMonth) == key;
  }
}
