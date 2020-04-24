import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_event.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

void main() {
  group('getEventOn', () {
    test('データが0件: 空の配列を返すこと', () {
      EventCollection collection = EventCollection();
      List<CalendarEvent> events = collection.getEventsOn(2020, 1, 1);

      expect(events.length, 0);
    });

    test('データが1件: 1件の配列を返すこと', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2020, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events = collection.getEventsOn(2020, 1, 1);
      expect(events.length, 1);
    });

    test('データが2件: 2件の配列を返すこと', () {
      List<CalendarEvent> events = [
        CalendarEvent(startDateTime: DateTime(2020, 1, 2)),
        CalendarEvent(startDateTime: DateTime(2020, 1, 2, 23, 59, 59)),
      ];
      EventCollection collection = EventCollection.fromList(events);

      List<CalendarEvent> result = collection.getEventsOn(2020, 1, 2);
      expect(result.length, 2);
    });

    Map<String, Map<String, dynamic>> datePatterns = {
      '1か月前': {'date': DateTime(2020, 1, 1, 0, 0, 0), 'expected': 0},
      '1日前': {'date': DateTime(2020, 1, 31, 0, 0, 0), 'expected': 0},
      '1秒前': {'date': DateTime(2020, 1, 31, 23, 59, 59), 'expected': 0},
      '当日': {'date': DateTime(2020, 2, 1, 0, 0, 0), 'expected': 1},
      '当日23:59:59': {'date': DateTime(2020, 2, 1, 23, 59, 59), 'expected': 1},
      '翌日00:00:00': {'date': DateTime(2020, 2, 2, 00, 00, 00), 'expected': 0},
      '翌月': {'date': DateTime(2020, 3, 1, 00, 00, 00), 'expected': 0},
    };
    datePatterns.forEach((String title, pattern) {
      test('' + title, () {
        CalendarEvent event = CalendarEvent(startDateTime: pattern['date']);
        EventCollection collection = EventCollection.fromList([event]);

        List<CalendarEvent> result = collection.getEventsOn(2020, 2, 1);
        expect(result.length, pattern['expected']);
      });
    });

    test('イベントの存在しない日を指定した場合: 空の配列を返すこと', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2020, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events = collection.getEventsOn(2020, 1, 2);
      expect(events.length, 0);
    });

    test('13月を指定した場合: 翌年1月として処理される', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2021, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events = collection.getEventsOn(2020, 13, 1);
      expect(events.length, 1);
    });

    test('32日を指定した場合: 翌月1日として処理される', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2021, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events = collection.getEventsOn(2020, 12, 32);
      expect(events.length, 1);
    });
  });

  group('getEventsByDate', () {
    test('データが0件: 空の配列を返すこと', () {
      EventCollection collection = EventCollection();
      List<CalendarEvent> events =
          collection.getEventsByDate(DateTime(2020, 1, 1));

      expect(events.length, 0);
    });

    test('データが1件: 1件の配列を返すこと', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2020, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events =
          collection.getEventsByDate(DateTime(2020, 1, 1));
      expect(events.length, 1);
    });

    test('データが2件: 2件の配列を返すこと', () {
      List<CalendarEvent> events = [
        CalendarEvent(startDateTime: DateTime(2020, 1, 2)),
        CalendarEvent(startDateTime: DateTime(2020, 1, 2, 23, 59, 59)),
      ];
      EventCollection collection = EventCollection.fromList(events);

      List<CalendarEvent> result =
          collection.getEventsByDate(DateTime(2020, 1, 2));
      expect(result.length, 2);
    });

    Map<String, Map<String, dynamic>> datePatterns = {
      '1か月前': {'date': DateTime(2020, 1, 1, 0, 0, 0), 'expected': 0},
      '1日前': {'date': DateTime(2020, 1, 31, 0, 0, 0), 'expected': 0},
      '1秒前': {'date': DateTime(2020, 1, 31, 23, 59, 59), 'expected': 0},
      '当日': {'date': DateTime(2020, 2, 1, 0, 0, 0), 'expected': 1},
      '当日23:59:59': {'date': DateTime(2020, 2, 1, 23, 59, 59), 'expected': 1},
      '翌日00:00:00': {'date': DateTime(2020, 2, 2, 00, 00, 00), 'expected': 0},
      '翌月': {'date': DateTime(2020, 3, 1, 00, 00, 00), 'expected': 0},
    };
    datePatterns.forEach((String title, pattern) {
      test('' + title, () {
        CalendarEvent event = CalendarEvent(startDateTime: pattern['date']);
        EventCollection collection = EventCollection.fromList([event]);

        List<CalendarEvent> result =
            collection.getEventsByDate(DateTime(2020, 2, 1));
        expect(result.length, pattern['expected']);
      });
    });

    test('イベントの存在しない日を指定した場合: 空の配列を返すこと', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2020, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events =
          collection.getEventsByDate(DateTime(2020, 1, 2));
      expect(events.length, 0);
    });

    test('13月を指定した場合: 翌年1月として処理される', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2021, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events =
          collection.getEventsByDate(DateTime(2020, 13, 1));
      expect(events.length, 1);
    });

    test('32日を指定した場合: 翌月1日として処理される', () {
      CalendarEvent event = CalendarEvent(startDateTime: DateTime(2021, 1, 1));
      EventCollection collection = EventCollection.fromList([event]);

      List<CalendarEvent> events =
          collection.getEventsByDate(DateTime(2020, 12, 32));
      expect(events.length, 1);
    });
  });

  group('setList', () {
    test('セットした内容で更新されること', () {
      CalendarEvent initialEvent =
          CalendarEvent(startDateTime: DateTime(2020, 1, 1));
      List<CalendarEvent> events = [
        CalendarEvent(startDateTime: DateTime(2020, 1, 2)),
        CalendarEvent(startDateTime: DateTime(2020, 1, 2, 23, 59, 59)),
      ];
      EventCollection collection = EventCollection();
      collection.add(initialEvent);

      List<CalendarEvent> foundEvents = collection.getEventsOn(2020, 1, 1);
      expect(foundEvents.length, 1, reason: '初期設定したイベントが取得できません');

      collection.setList(events);
      foundEvents = collection.getEventsOn(2020, 1, 1);
      expect(foundEvents.length, 0, reason: '初期設定したイベントが削除されていません');
      foundEvents = collection.getEventsOn(2020, 1, 2);
      expect(foundEvents.length, 2, reason: 'セットしたイベントが取得できません');
    });
  });
}
