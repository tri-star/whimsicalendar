import 'package:whimsicalendar/domain/user/user.dart';

import 'calendar_event.dart';

/// カレンダーのイベントを扱うリポジトリ
abstract class CalendarEventRepositoryInterface {
  void save(User user, CalendarEvent e);
}
