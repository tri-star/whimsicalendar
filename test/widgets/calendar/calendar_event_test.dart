import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_event.dart';

void main() {
  group('初期化', () {
    test('nameの初期値', () {
      String expectedName = 'test';
      CalendarEvent event = CalendarEvent(name: expectedName);
      expect(event.name, expectedName);
    });
    test('nameの初期値:未設定', () {
      CalendarEvent event = CalendarEvent();
      expect(event.name, '');
    });

    test('startDateTimeの初期値', () {
      DateTime expectedDate = DateTime(2020, 1, 2, 3, 4, 5);
      CalendarEvent event = CalendarEvent(startDateTime: expectedDate);
      expect(event.startDateTime, expectedDate);
    });

    test('startDateTimeの初期値:未設定', () {
      CalendarEvent event = CalendarEvent();
      expect(event.startDateTime, null);
    });

    test('endDateTimeの初期値', () {
      DateTime expectedDate = DateTime(2020, 1, 2, 3, 4, 5);
      CalendarEvent event = CalendarEvent(endDateTime: expectedDate);
      expect(event.endDateTime, expectedDate);
    });

    test('endDateTimeの初期値:未設定', () {
      CalendarEvent event = CalendarEvent();
      expect(event.endDateTime, null);
    });

    test('isAllDayの初期値', () {
      bool expectedValue = true;
      CalendarEvent event = CalendarEvent(isAllDay: expectedValue);
      expect(event.isAllDay, expectedValue);
    });
    test('isAllDayの初期値:未指定', () {
      CalendarEvent event = CalendarEvent();
      expect(event.isAllDay, false);
    });
  });

  group('getStartDate', () {
    test('時刻指定された時間を指定しても、00:00:00で返されること', () {
      CalendarEvent event =
          CalendarEvent(startDateTime: DateTime(2020, 1, 2, 10, 11, 12));
      expect(event.getStartDate().year, 2020);
      expect(event.getStartDate().month, 1);
      expect(event.getStartDate().day, 2);
      expect(event.getStartDate().hour, 0);
      expect(event.getStartDate().minute, 0);
      expect(event.getStartDate().second, 0);
    });

    test('nullの場合はnullが返ること', () {
      CalendarEvent event = CalendarEvent();
      expect(event.getStartDate(), null);
    });
  });

  group('getEndDate', () {
    test('時刻指定された時間を指定しても、00:00:00で返されること', () {
      CalendarEvent event =
          CalendarEvent(endDateTime: DateTime(2020, 1, 2, 10, 11, 12));
      expect(event.getEndDate().year, 2020);
      expect(event.getEndDate().month, 1);
      expect(event.getEndDate().day, 2);
      expect(event.getEndDate().hour, 0);
      expect(event.getEndDate().minute, 0);
      expect(event.getEndDate().second, 0);
    });

    test('nullの場合はnullが返ること', () {
      CalendarEvent event = CalendarEvent();
      expect(event.getEndDate(), null);
    });
  });
}
