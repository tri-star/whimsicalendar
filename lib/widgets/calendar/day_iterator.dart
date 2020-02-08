/// 指定された年月の日をカレンダー表示用に列挙する
class DayIterator {
  final DateTime _baseDate;
  final bool _isStartFromSunday;

  DayIterator(int year, int month, {bool isStartFromSunday: true})
      : _baseDate = DateTime(year, month, 1),
        _isStartFromSunday = isStartFromSunday;

  /// カレンダー上の最初の日(例:1日がある週の最初の日曜)から最後の週の最後の日までを列挙するイテレータ
  Iterable<DateTime> next() sync* {
    //1日の週の最初の曜日を求める
    DateTime firstWeekDay =
        _baseDate.subtract(Duration(days: _baseDate.weekday));

    //最終日の週の最後の曜日を求める
    DateTime finalDay = getFinalWeekDayDate();

    var currentDate = firstWeekDay;
    while (currentDate.compareTo(finalDay) < 1) {
      yield currentDate;
      currentDate = currentDate.add(Duration(days: 1));
    }
  }

  /// 最後の週の最後の日を返す
  DateTime getFinalWeekDayDate() {
    DateTime finalDay = getFinalDay(_baseDate);
    int offset = 6 - finalDay.weekday;
    if (offset < 0) {
      offset += 7;
    }

    return finalDay.add(Duration(days: offset));
  }

  /// 指定された月の最後の日を返す
  static DateTime getFinalDay(DateTime date) {
    DateTime nextMonthDate = DateTime(date.year, date.month + 1, 1);
    Duration difference = nextMonthDate.difference(date);

    return date.add(Duration(days: difference.inDays - 1));
  }
}
