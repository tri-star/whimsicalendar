import 'package:whimsicalendar/widgets/calendar/calendar_controller.dart';

/// カレンダー全体に対するViewModel
class CalendarViewModel {
  CalendarController calendarController;

  DateTime currentDate;

  CalendarViewModel() {
    calendarController = CalendarController(onDateChangeHandler: onDateChanged);
  }

  void onDateChanged(DateTime newDate) {
    currentDate = newDate;
  }
}
