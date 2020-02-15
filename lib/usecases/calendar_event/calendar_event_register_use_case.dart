import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';

/// カレンダーイベントの登録処理
class CalendarEventRegisterUseCase {
  CalendarEventRepositoryInterface calendarEventRepository;

  CalendarEventRegisterUseCase(this.calendarEventRepository);

  Future<void> execute(User user, CalendarEvent event) async {
    this.calendarEventRepository.save(user, event);
  }
}
