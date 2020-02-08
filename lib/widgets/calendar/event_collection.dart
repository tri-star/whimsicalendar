import 'package:whimsicalendar/widgets/calendar/calendar_event.dart';

/// カレンダーのイベントの一覧を管理する
class EventCollection<T extends CalendarEvent> {
  Map<DateTime, List<T>> _events;

  /// 指定された日のイベントを全て返す
  List<T> getEventsOn(DateTime date) {
    if (!_events.containsKey(date)) {
      return [];
    }
    return _events[date];
  }

  /// 指定した日にイベントを追加する
  void addEvent(DateTime date, T event) {
    _events[date].add(event);
  }
}
