import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_controller.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

/// カレンダー全体に対するViewModel
class CalendarViewModel with ChangeNotifier {
  CalendarController calendarController;

  DateTime currentDate;

  /// 現在イベント一覧をロードしている月
  DateTime _loadedMonth;

  BuildContext _context;

  EventCollection<CalendarEvent> _eventCollection;

  CalendarViewModel(BuildContext context) {
    calendarController = CalendarController(
        onDateChangeHandler: onDateChanged,
        onMonthChangeHandler: onMonthChanged,
        onDateLongTapHandler: onDateLongTapped);
    _context = context;
    currentDate = null;
    _loadedMonth = null;
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

    await showDialog<void>(
        context: _context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('予定一覧'),
            children: [
              for (var event in events)
                Column(children: [ListTile(title: Text(event.name))])
            ],
          );
        });
  }

  /// イベント一覧の再ロードが必要かを返す
  bool shouldUpdateEventList() {
    return _loadedMonth != calendarController.currentMonth;
  }

  /// イベント一覧を再ロードする
  void loadEventList() async {
    DateTime currentMonth = calendarController.currentMonth;
    CalendarEventRepositoryInterface repository =
        Provider.of<CalendarEventRepositoryInterface>(_context, listen: false);
    AuthenticatorInterface authenticator =
        Provider.of<AuthenticatorInterface>(_context, listen: false);
    User user = await authenticator.getUser();

    _eventCollection = await repository.getCalendarEventByMonth(
        user.id, currentMonth.year, currentMonth.month);

    calendarController.setEventCollection(_eventCollection);
    _loadedMonth = calendarController.currentMonth;
    notifyListeners();
  }
}
