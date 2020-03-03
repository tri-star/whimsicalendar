import 'package:whimsicalendar/domain/user/user.dart';

import '../../widgets/calendar/event_collection.dart';
import 'calendar_event.dart';

/// カレンダーのイベントを扱うリポジトリ
abstract class CalendarEventRepositoryInterface {
  /// イベントの情報を保存する
  void save(User user, CalendarEvent e);

  /// 指定した月のイベントの一覧を取得する
  Future<EventCollection<CalendarEvent>> getCalendarEventByMonth(
      String userId, int year, int month);
}
