import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_controller.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

typedef OnDateLongTappedFunction = void Function(
    DateTime dateTime, List<CalendarEvent> events);

/// カレンダー全体に対するViewModel
class CalendarViewModel with ChangeNotifier {
  CalendarController calendarController;

  DateTime currentDate;

  /// 現在イベント一覧をロードしている月
  DateTime _loadedMonth;

  AuthenticatorInterface _authenticator;
  CalendarEventRepositoryInterface _calendarEventRepository;

  EventCollection<CalendarEvent> _eventCollection;

  OnDateLongTappedFunction _onDateLongTapped;

  CalendarViewModel(
      {AuthenticatorInterface authenticator,
      CalendarEventRepositoryInterface calendarEventRepository}) {
    _authenticator = authenticator;
    _calendarEventRepository = calendarEventRepository;
    calendarController = CalendarController(
        onDateChangeHandler: onDateChanged,
        onMonthChangeHandler: onMonthChanged,
        onDateLongTapHandler: onDateLongTapped);
    currentDate = null;
    _loadedMonth = null;
    _onDateLongTapped = null;
  }

  void init({OnDateLongTappedFunction onDateLongTapped}) {
    _onDateLongTapped = onDateLongTapped;
  }

  void onDateChanged(DateTime newDate) {
    currentDate = newDate;
  }

  /// 表示している月が変わった時のコールバック
  void onMonthChanged(DateTime newMonth) {
    loadEventList();
  }

  /// 日付をロングタップした場合の処理
  void onDateLongTapped(DateTime dateTime) async {
    if (_eventCollection == null) {
      return;
    }

    List<CalendarEvent> events = _eventCollection.getEventsByDate(dateTime);
    if (events.length == 0) {
      return;
    }

    _onDateLongTapped?.call(dateTime, events);
  }

  /// イベント一覧の再ロードが必要かを返す
  bool shouldUpdateEventList() {
    return _loadedMonth != calendarController.currentMonth;
  }

  /// イベント一覧を再ロードする
  void loadEventList() async {
    DateTime currentMonth = calendarController.currentMonth;
    User user = await _authenticator.getUser();

    _eventCollection = await _calendarEventRepository.getCalendarEventByMonth(
        user.id, currentMonth.year, currentMonth.month);

    calendarController.setEventCollection(_eventCollection);
    _loadedMonth = calendarController.currentMonth;
    notifyListeners();
  }
}
