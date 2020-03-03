import 'package:intl/intl.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_event.dart';

/// 1か月分のイベントの一覧を保持するクラス
class EventCollection<T extends CalendarEvent> {
  List<T> _events;
  Map<String, List<T>> _cache;

  EventCollection()
      : _events = List<T>(),
        _cache = {};

  EventCollection.fromList(List<T> events)
      : _events = events,
        _cache = {};

  /// 指定された日のイベントの一覧を返す
  List<T> getEventsOn(int year, int month, int day) {
    String cacheKey = _getKey(year, month, day);
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey];
    }

    _cache[cacheKey] = [];

    DateTime dateFrom = DateTime(year, month, day);
    DateTime dateTo =
        DateTime(year, month, day + 1).subtract(Duration(seconds: 1));
    _events.forEach((CalendarEvent event) {
      if (event.startDateTime.isBefore(dateFrom) ||
          event.startDateTime.isAfter(dateTo)) {
        return;
      }
      _cache[cacheKey].add(event);
    });

    return _cache[cacheKey];
  }

  /// イベントを追加する
  void add(T event) {
    String cacheKey = _getKey(event.startDateTime.year,
        event.startDateTime.month, event.startDateTime.day);
    if (_cache.containsKey(cacheKey)) {
      _cache.remove(cacheKey);
    }
    _events.add(event);
  }

  /// イベント一覧を更新する
  void setList(List<T> list) {
    _cache = {};
    _events = list;
  }

  _getKey(int year, int month, int day) {
    var digitFormat = NumberFormat('00');
    return '${year}-${digitFormat.format(month)}-${digitFormat.format(day)}';
  }
}
