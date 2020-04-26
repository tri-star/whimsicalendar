import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/infrastructure/auth/stub_authenticator.dart';
import 'package:whimsicalendar/infrastructure/repositories/calendar_event/stub_calendar_event_repository.dart';
import 'package:whimsicalendar/pages/calendar/calendar_view_model.dart';

CalendarViewModel viewModel;
StubAuthenticator stubAuthenticator;
StubCalendarEventRepository stubCalendarEventRepository;

CalendarViewModel _createViewModel() {
  return CalendarViewModel(
      authenticator: stubAuthenticator,
      calendarEventRepository: stubCalendarEventRepository);
}

Future<void> loadEvents(
    CalendarViewModel viewModel, List<CalendarEvent> events) async {
  if (events != null && events.length > 0) {
    for (CalendarEvent event in events) {
      stubCalendarEventRepository.save(
          await stubAuthenticator.getUser(), event);
    }
  }

  await viewModel.loadEventList();
}

void main() {
  group('CalendarViewModel', () {
    setUp(() {
      stubAuthenticator = StubAuthenticator();
      stubCalendarEventRepository = StubCalendarEventRepository();

      User user = User(id: '1');
      stubAuthenticator.setUserForTest(user);
    });

    group('onDateLongTapped', () {
      test('init前に呼び出してもエラーにはならないこと', () {
        CalendarViewModel model = _createViewModel();

        bool isError = false;
        try {
          model.onDateLongTapped(DateTime(2020, 1, 1));
        } catch (e) {
          isError = true;
        }
        expect(isError, false);
      });

      test('イベント一覧のロード前の場合: コールバック関数は呼び出されないこと', () {
        CalendarViewModel model = _createViewModel();
        bool called = false;
        model.init(
            onDateLongTapped: (DateTime dateTime, List<CalendarEvent> events) {
          called = true;
        });
        model.onDateLongTapped(DateTime(2020, 1, 1));
        expect(called, false);
      });

      test('イベント一覧が空の場合: コールバック関数は呼び出されないこと', () async {
        CalendarViewModel viewModel = _createViewModel();

        viewModel.setCurrentMonth(DateTime(2020, 1, 1));
        await loadEvents(viewModel, []);

        bool called = false;
        viewModel.init(
            onDateLongTapped: (DateTime dateTime, List<CalendarEvent> events) {
          called = true;
        });
        viewModel.onDateLongTapped(DateTime(2020, 1, 1));
        expect(called, false);
      });

      test('該当イベントなしの場合: コールバック関数は呼び出されないこと', () async {
        CalendarViewModel viewModel = _createViewModel();

        viewModel.setCurrentMonth(DateTime(2020, 1, 1));
        await loadEvents(viewModel,
            [CalendarEvent(id: '1', startDateTime: DateTime(2020, 2, 1))]);

        bool called = false;
        viewModel.init(
            onDateLongTapped: (DateTime dateTime, List<CalendarEvent> events) {
          called = true;
        });
        viewModel.onDateLongTapped(DateTime(2020, 1, 1));
        expect(called, false);
      });

      test('該当イベントありの場合: コールバック関数が呼び出されること', () async {
        CalendarViewModel viewModel = _createViewModel();

        viewModel.setCurrentMonth(DateTime(2020, 1, 1));
        await loadEvents(viewModel,
            [CalendarEvent(id: '1', startDateTime: DateTime(2020, 1, 1))]);

        bool called = false;
        viewModel.init(
            onDateLongTapped: (DateTime dateTime, List<CalendarEvent> events) {
          called = true;
        });
        viewModel.onDateLongTapped(DateTime(2020, 1, 1));
        expect(called, true);
      });
    });
  });
}
