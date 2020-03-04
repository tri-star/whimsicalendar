import 'package:flutter/cupertino.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

import 'calendar_event.dart';

typedef OnDateChangeHandler = void Function(DateTime);
typedef OnMonthChangeHandler = void Function(DateTime);

/// カレンダーの状態を保持するオブジェクト
class CalendarController<T extends CalendarEvent> with ChangeNotifier {
  /// スワイプによるスクロールの方向
  int scrollDirection;

  /// 現在表示している月
  DateTime _currentMonth;

  /// 現在選択している日付。null = 未選択
  DateTime _selectedDate;

  /// カレンダーのイベント一覧
  EventCollection<T> _eventCollection;

  /// 日付の選択が変わった場合に呼び出される
  List<OnDateChangeHandler> _onDateChangeHandlers;

  List<OnMonthChangeHandler> _onMonthChangeHandlers;

  CalendarController(
      {EventCollection<T> eventCollection,
      OnDateChangeHandler onDateChangeHandler,
      OnMonthChangeHandler onMonthChangeHandler})
      : _currentMonth = null,
        _selectedDate = null,
        _eventCollection = eventCollection,
        _onDateChangeHandlers = [],
        _onMonthChangeHandlers = [] {
    if (_currentMonth == null) {
      _currentMonth = DateTime.now();
    }
    if (_eventCollection == null) {
      _eventCollection = new EventCollection<T>();
    }
    if (onDateChangeHandler != null) {
      _onDateChangeHandlers.add(onDateChangeHandler);
    }
    if (onMonthChangeHandler != null) {
      _onMonthChangeHandlers.add(onMonthChangeHandler);
    }
  }

  set currentMonth(DateTime date) {
    bool changed = _currentMonth.compareTo(date) != 0;
    _currentMonth = date;
    if (changed) {
      _onMonthChangeHandlers.forEach((OnMonthChangeHandler handler) {
        handler(_currentMonth);
      });
    }
    notifyListeners();
  }

  set selectedDate(DateTime date) {
    bool changed =
        _selectedDate == null ? true : _selectedDate.compareTo(date) != 0;
    _selectedDate = date;
    if (changed) {
      notifyDateChanged();
    }
    notifyListeners();
  }

  DateTime get currentMonth => _currentMonth;
  DateTime get selectedDate => _selectedDate;

  /// 次の月に変更する
  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    _onMonthChangeHandlers.forEach((OnMonthChangeHandler handler) {
      handler(_currentMonth);
    });
    scrollDirection = -1;
    notifyListeners();
  }

  /// 前の月に変更する
  void goToPrevMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    _onMonthChangeHandlers.forEach((OnMonthChangeHandler handler) {
      handler(_currentMonth);
    });
    scrollDirection = 1;
    notifyListeners();
  }

  /// イベントの一覧を差し替える
  void setEventCollection(EventCollection collection) {
    _eventCollection = collection;
    notifyListeners();
  }

  /// 指定された日のイベントの一覧を返す
  List<T> getEventsOn(DateTime date) {
    return _eventCollection.getEventsOn(date.year, date.month, date.day);
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

  void notifyDateChanged() {
    _onDateChangeHandlers.forEach((OnDateChangeHandler handler) {
      handler(_selectedDate);
    });
  }
}
