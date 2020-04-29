import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';

/// カレンダーイベントの登録/更新処理
class CalendarEventSaveUseCase {
  CalendarEventRepositoryInterface calendarEventRepository;

  CalendarEventSaveUseCase(this.calendarEventRepository);

  Future<void> execute(User user, CalendarEvent event) async {
    await this.calendarEventRepository.save(user, event);
  }
}
