import 'package:flutter/cupertino.dart';

/// カレンダーの状態を保持するオブジェクト
class CalendarController with ChangeNotifier {
  /// スワイプによるスクロールの方向
  int scrollDirection;

  /// 現在表示している月
  DateTime _currentMonth;

  /// 現在選択している日付。null = 未選択
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

  /// 次の月に変更する
  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    scrollDirection = -1;
    notifyListeners();
  }

  /// 前の月に変更する
  void goToPrevMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    scrollDirection = 1;
    notifyListeners();
  }

  /// 指定したキーが次の月を指しているかを返す
  bool isNextMonthKey(ValueKey key) {
    DateTime nextMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    return ValueKey(nextMonth) == key;
  }

  /// 指定したキーが前の月を指しているかを返す
  bool isPrevMonthKey(ValueKey key) {
    DateTime prevMonth =
        DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    return ValueKey(prevMonth) == key;
  }
}
