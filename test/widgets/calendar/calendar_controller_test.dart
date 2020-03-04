import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_controller.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

void main() {
  group('初期値', () {
    test('currentMonth', () {
      CalendarController controller = CalendarController();
      DateTime now = DateTime.now();
      expect(controller.currentMonth.year, now.year);
      expect(controller.currentMonth.month, now.month);
    });

    test('selectedDate', () {
      CalendarController controller = CalendarController();
      expect(controller.selectedDate, null);
    });
  });

  group('currentMonth', () {
    test('変更できること', () {
      CalendarController controller = CalendarController();
      DateTime expectedMonth = DateTime(2000, 1, 1);
      controller.currentMonth = expectedMonth;
      expect(controller.currentMonth, expectedMonth);
    });
    test('変更した場合はコールバックが呼ばれること', () {
      DateTime expectedMonth = DateTime(2000, 1, 1);
      DateTime changedMonth;
      OnMonthChangeHandler callback = (DateTime d) {
        changedMonth = d;
      };
      CalendarController controller =
          CalendarController(onMonthChangeHandler: callback);
      controller.currentMonth = expectedMonth;
      expect(changedMonth, expectedMonth);
    });
    test('変更しない場合はコールバックが呼ばれないこと', () {
      int count = 0;
      OnMonthChangeHandler callback = (DateTime d) {
        count++;
      };
      CalendarController controller =
          CalendarController(onMonthChangeHandler: callback);
      controller.currentMonth =
          DateTime(2001, 1, 1); // 初期値のnowから変化するので1回はcallbackが呼ばれる
      controller.currentMonth = DateTime(2001, 1, 1);
      expect(count, 1, reason: 'currentMonthを変更していないのにコールバックが呼び出されています');
    });
  });

  // selectedDateを変更できる
  group('selectedDate', () {
    test('変更できること', () {
      CalendarController controller = CalendarController();
      DateTime expectedDate = DateTime(2000, 1, 1);
      controller.selectedDate = expectedDate;
      expect(controller.selectedDate, expectedDate);
    });
    test('変更した場合はコールバックが呼ばれること', () {
      DateTime expectedDate = DateTime(2000, 1, 1);
      DateTime changedDate;
      OnDateChangeHandler callback = (DateTime d) {
        changedDate = d;
      };
      CalendarController controller =
          CalendarController(onDateChangeHandler: callback);
      controller.selectedDate = expectedDate;
      expect(changedDate, expectedDate);
    });
    test('変更しない場合はコールバックが呼ばれないこと', () {
      int count = 0;
      OnDateChangeHandler callback = (DateTime d) {
        count++;
      };
      CalendarController controller =
          CalendarController(onDateChangeHandler: callback);
      controller.selectedDate =
          DateTime(2001, 1, 1); // 初期値のnowから変化するので1回はcallbackが呼ばれる
      controller.selectedDate = DateTime(2001, 1, 1);
      expect(count, 1, reason: 'selectedDateを変更していないのにコールバックが呼び出されています');
    });
  });

  group('goToNextMonth', () {
    test('変更できること', () {
      CalendarController controller = CalendarController();
      DateTime initialDate = DateTime(2000, 1, 1);
      DateTime expectedDate = DateTime(2000, 2, 1);
      controller.currentMonth = initialDate;
      controller.goToNextMonth();
      expect(controller.currentMonth, expectedDate);
    });
    test('変更した場合はコールバックが呼ばれること', () {
      DateTime initialDate = DateTime(2000, 1, 1);
      DateTime expectedDate = DateTime(2000, 2, 1);
      DateTime changedMonth;
      OnMonthChangeHandler callback = (DateTime d) {
        changedMonth = d;
      };
      CalendarController controller =
          CalendarController(onMonthChangeHandler: callback);
      controller.currentMonth = initialDate;
      controller.goToNextMonth();
      expect(changedMonth, expectedDate);
    });
  });

  group('goToPrevMonth', () {
    test('変更できること', () {
      CalendarController controller = CalendarController();
      DateTime initialDate = DateTime(2000, 1, 1);
      DateTime expectedDate = DateTime(1999, 12, 1);
      controller.currentMonth = initialDate;
      controller.goToPrevMonth();
      expect(controller.currentMonth, expectedDate);
    });
    test('変更した場合はコールバックが呼ばれること', () {
      DateTime initialDate = DateTime(2000, 1, 1);
      DateTime expectedDate = DateTime(1999, 12, 1);
      DateTime changedMonth;
      OnMonthChangeHandler callback = (DateTime d) {
        changedMonth = d;
      };
      CalendarController controller =
          CalendarController(onMonthChangeHandler: callback);
      controller.currentMonth = initialDate;
      controller.goToPrevMonth();
      expect(changedMonth, expectedDate);
    });
  });

  group('getEventsOn', () {
    test('指定した日のイベントを取得できること', () {
      CalendarController controller = CalendarController();
      DateTime date = DateTime(2000, 1, 1);
      EventCollection collection = EventCollection<CalendarEvent>.fromList([
        CalendarEvent(startDateTime: date),
        CalendarEvent(startDateTime: date),
        CalendarEvent(startDateTime: date.add(Duration(days: 1)))
      ]);
      controller.setEventCollection(collection);

      List<CalendarEvent> events = controller.getEventsOn(date);
      expect(events.length, 2);
    });

    test('イベント0件で呼び出してもエラーにならないこと', () {
      CalendarController controller = CalendarController();
      DateTime date = DateTime(2000, 1, 1);
      EventCollection collection = EventCollection<CalendarEvent>();
      controller.setEventCollection(collection);

      List<CalendarEvent> events = controller.getEventsOn(date);
      expect(events.length, 0);
    });
  });

  group('isNextMonthKey', () {
    test('一致する場合', () {
      DateTime currentMonth = DateTime(2000, 1, 1);
      CalendarController controller = CalendarController();
      controller.currentMonth = currentMonth;

      ValueKey<DateTime> key = ValueKey<DateTime>(DateTime(2000, 2, 1));
      expect(controller.isNextMonthKey(key), true);
    });
    test('一致しない場合', () {
      DateTime currentMonth = DateTime(2000, 1, 1);
      CalendarController controller = CalendarController();
      controller.currentMonth = currentMonth;

      ValueKey<DateTime> key = ValueKey<DateTime>(DateTime(2000, 1, 2));
      expect(controller.isNextMonthKey(key), false);
    });
  });

  group('isPrevMonthKey', () {
    test('一致する場合', () {
      DateTime currentMonth = DateTime(2000, 1, 1);
      CalendarController controller = CalendarController();
      controller.currentMonth = currentMonth;

      ValueKey<DateTime> key = ValueKey<DateTime>(DateTime(1999, 12, 1));
      expect(controller.isPrevMonthKey(key), true);
    });
    test('一致しない場合', () {
      DateTime currentMonth = DateTime(2000, 1, 1);
      CalendarController controller = CalendarController();
      controller.currentMonth = currentMonth;

      ValueKey<DateTime> key = ValueKey<DateTime>(DateTime(1999, 11, 1));
      expect(controller.isPrevMonthKey(key), false);
    });
  });
}
