import 'package:flutter/widgets.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_controller.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

/// カレンダー全体に対するViewModel
class CalendarViewModel {
  CalendarController calendarController;

  DateTime currentDate;

  /// 現在イベント一覧をロードしている月
  DateTime _loadedMonth;

  CalendarViewModel() {
    calendarController = CalendarController(onDateChangeHandler: onDateChanged);
    currentDate = null;
    _loadedMonth = null;
  }

  void onDateChanged(DateTime newDate) {
    currentDate = newDate;
  }

  /// イベント一覧の再ロードが必要かを返す
  bool shouldUpdateEventList() {
    return _loadedMonth != calendarController.currentMonth;
  }

  /// イベント一覧を再ロードする
  void loadEventList(BuildContext context) {
    EventCollection<CalendarEvent> collection =
        EventCollection<CalendarEvent>();

    collection
      ..add(CalendarEvent(name: 'test', startDateTime: DateTime(2020, 3, 2)))
      ..add(CalendarEvent(name: 'test2', startDateTime: DateTime(2020, 3, 3)));

    calendarController.setEventCollection(collection);
    _loadedMonth = calendarController.currentMonth;
  }
}
