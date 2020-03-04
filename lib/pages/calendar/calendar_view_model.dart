import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_controller.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

/// カレンダー全体に対するViewModel
class CalendarViewModel {
  CalendarController calendarController;

  DateTime currentDate;

  /// 現在イベント一覧をロードしている月
  DateTime _loadedMonth;

  BuildContext _context;

  CalendarViewModel(BuildContext context) {
    calendarController = CalendarController(
        onDateChangeHandler: onDateChanged,
        onMonthChangeHandler: onMonthChanged);
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

    EventCollection<CalendarEvent> collection =
        await repository.getCalendarEventByMonth(
            user.id, currentMonth.year, currentMonth.month);

    calendarController.setEventCollection(collection);
    _loadedMonth = calendarController.currentMonth;
  }
}
