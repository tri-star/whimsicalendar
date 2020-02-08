import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/widgets/calendar/day_iterator.dart';

void main() {
  test('最初の日付', () {
    DateTime baseDate = DateTime(2020, 02, 01);
    DateTime expectedDate = DateTime(2020, 01, 26);
    DayIterator dayIterator = DayIterator(baseDate.year, baseDate.month);

    var iterator = dayIterator.next();
    var i = iterator.first;

    expect(getDateString(expectedDate), equals(getDateString(i)),
        reason: 'カレンダー上の最初の日付が一致しません');
  });

  test('最後の日付', () {
    DateTime baseDate = DateTime(2020, 02, 01);
    DateTime expectedDate = DateTime(2020, 02, 29);

    DateTime lastDay = DayIterator.getFinalDay(baseDate);
    expect(getDateString(lastDay), equals(getDateString(expectedDate)));
  });

  group('最後の曜日の日付', () {
    List<Map<String, DateTime>> testCases = [
      {'base': DateTime(2020, 2, 1), 'expected': DateTime(2020, 2, 29)},
      {'base': DateTime(2020, 5, 1), 'expected': DateTime(2020, 6, 6)},
      {'base': DateTime(2020, 9, 1), 'expected': DateTime(2020, 10, 3)}
    ];

    testCases.forEach((t) {
      test('${t['base']}', () {
        DateTime baseDate = t['base'];
        DateTime expectedDate = t['expected'];
        DayIterator dayIterator = DayIterator(baseDate.year, baseDate.month);

        DateTime date = dayIterator.getFinalWeekDayDate();
        expect(getDateString(date), equals(getDateString(expectedDate)));
      });
    });
  });
}

String getDateString(DateTime d) {
  return '${d.year}-${d.month}-${d.day}';
}
