import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/infrastructure/auth/stub_authenticator.dart';
import 'package:whimsicalendar/infrastructure/repositories/calendar_event/stub_calendar_event_repository.dart';
import 'package:whimsicalendar/pages/event/edit_form_view_model.dart';
import 'package:whimsicalendar/usecases/calendar_event/calendar_event_save_use_case.dart';

StubAuthenticator stubAuthenticator;
StubCalendarEventRepository stubCalendarEventRepository;
EditFormViewModel viewModel;

class TestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestFormState();
}

class TestFormState extends State<TestForm> {
  @override
  Widget build(BuildContext context) {
    // FormKey
    return MaterialApp(
        home: Scaffold(
            body: Form(
                key: viewModel.formKey,
                child: Column(children: [
                  TextFormField(
                    controller: viewModel.nameController,
                    validator: (_) => viewModel.validateName(),
                  ),
                ]))));
  }
}

void main() {
  group('EditFormViewModel', () {
    setUp(() {
      stubAuthenticator = StubAuthenticator();
      stubCalendarEventRepository = StubCalendarEventRepository();
      var useCase = CalendarEventSaveUseCase(stubCalendarEventRepository);
      var user = User(id: 'aaa');
      stubAuthenticator.setUserForTest(user);

      viewModel =
          EditFormViewModel(authenticator: stubAuthenticator, useCase: useCase);
    });

    group('name', () {
      test('get: 参照できること', () {
        var event = CalendarEvent(name: 'test');
        viewModel.init(event);

        expect(viewModel.name, 'test');
      });

      test('set: 変更が反映されていること', () {
        var event = CalendarEvent(name: 'test');
        viewModel.init(event);
        viewModel.name = 'updated';

        expect(viewModel.name, 'updated');
      });
      test('set: 変更が通知されること', () {
        var event = CalendarEvent(name: 'test');
        bool notified = false;
        viewModel.init(event);
        viewModel.addListener(() {
          notified = true;
        });

        viewModel.name = 'updated';
        expect(notified, true);
      });
    });

    group('url', () {
      test('get: 参照できること', () {
        const String value = 'http://example.com/';
        var event = CalendarEvent(url: value);
        viewModel.init(event);

        expect(viewModel.url, value);
      });
      test('set: 変更が反映されていること', () {
        var event = CalendarEvent(url: 'some url');
        viewModel.init(event);
        const String value = 'http://example.com/';
        viewModel.url = value;

        expect(viewModel.url, value);
      });
      test('set: 変更が通知されること', () {
        var event = CalendarEvent(url: 'some url.');
        bool notified = false;
        viewModel.init(event);
        viewModel.addListener(() {
          notified = true;
        });
        const String value = 'http://example.com/';
        viewModel.url = value;
        expect(notified, true);
      });
    });

    group('isAllDay', () {
      test('get: 参照できること', () {
        var event = CalendarEvent(isAllDay: true);
        viewModel.init(event);
        expect(viewModel.isAllDay, true);
      });
      test('set: 変更が反映されていること', () {
        var event = CalendarEvent(isAllDay: true);
        viewModel.init(event);
        viewModel.isAllDay = false;
        expect(viewModel.isAllDay, false);
      });
      test('set: 変更が通知されること', () {
        var event = CalendarEvent(isAllDay: true);
        bool notified = false;
        viewModel.init(event);
        viewModel.addListener(() {
          notified = true;
        });
        viewModel.isAllDay = false;
        expect(notified, true);
      });
    });

    group('startDateTime', () {
      test('get: 開始日時を参照できること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(startDateTime: dateTime);
        viewModel.init(event);
        expect(viewModel.startDateTime, dateTime);
      });
    });

    group('startDate', () {
      test('get: 開始日を参照できること', () {
        var dateTime = DateTime(2020, 1, 1);
        var event = CalendarEvent(startDateTime: dateTime);
        viewModel.init(event);
        expect(viewModel.startDate, dateTime);
      });
      test('get: 日時が指定されている予定の場合、00:00:00として取得できること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var expectedDateTime = DateTime(2020, 1, 1, 0, 0, 0);
        var event = CalendarEvent(startDateTime: dateTime);
        viewModel.init(event);
        expect(viewModel.startDate, expectedDateTime);
      });
      test('set: 変更が反映されていること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(startDateTime: dateTime);
        viewModel.init(event);
        var newDateTime = DateTime(2020, 1, 2, 10, 11, 12);
        var expectedDateTime = DateTime(2020, 1, 2, 0, 0, 0);
        viewModel.startDate = newDateTime;

        expect(viewModel.startDate, expectedDateTime);
      });
      test('set: 変更が通知されること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(startDateTime: dateTime);
        bool notified = false;
        viewModel.addListener(() {
          notified = true;
        });
        viewModel.init(event);
        var newDateTime = DateTime(2020, 1, 2, 10, 11, 12);
        viewModel.startDate = newDateTime;

        expect(notified, true);
      });
      test('set: nullを渡した場合は変化しないこと', () {
        var expectedDateTime = DateTime(2020, 1, 1);
        var event = CalendarEvent(startDateTime: expectedDateTime);
        viewModel.init(event);
        viewModel.startDate = null;

        expect(viewModel.startDate, expectedDateTime);
      });
    });

    group('endDate', () {
      test('get: 終了日を参照できること', () {
        var dateTime = DateTime(2020, 1, 1);
        var event = CalendarEvent(endDateTime: dateTime);
        viewModel.init(event);
        expect(viewModel.endDate, dateTime);
      });
      test('get: 日時が指定されている予定の場合、00:00:00として取得できること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var expectedDateTime = DateTime(2020, 1, 1, 0, 0, 0);
        var event = CalendarEvent(endDateTime: dateTime);
        viewModel.init(event);
        expect(viewModel.endDate, expectedDateTime);
      });
      test('set: 変更が反映されていること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(endDateTime: dateTime);
        viewModel.init(event);
        var newDateTime = DateTime(2020, 1, 2, 10, 11, 12);
        var expectedDateTime = DateTime(2020, 1, 2, 0, 0, 0);
        viewModel.endDate = newDateTime;

        expect(viewModel.endDate, expectedDateTime);
      });
      test('set: 変更が通知されること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(endDateTime: dateTime);
        bool notified = false;
        viewModel.addListener(() {
          notified = true;
        });
        viewModel.init(event);
        var newDateTime = DateTime(2020, 1, 2, 10, 11, 12);
        viewModel.endDate = newDateTime;

        expect(notified, true);
      });
      test('set: nullを渡した場合は変化しないこと', () {
        var expectedDateTime = DateTime(2020, 1, 1);
        var event = CalendarEvent(endDateTime: expectedDateTime);
        viewModel.init(event);
        viewModel.endDate = null;

        expect(viewModel.endDate, expectedDateTime);
      });
    });

    group('startTime', () {
      test('get: 開始日時の時刻を取得できること', () {
        var expectedDateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(startDateTime: expectedDateTime);
        viewModel.init(event);
        expect(viewModel.startTime, TimeOfDay(hour: 10, minute: 11));
      });
      test('get: 開始日時がnullの場合はnullが返却されること', () {
        var event = CalendarEvent(startDateTime: null);
        viewModel.init(event);
        expect(viewModel.startTime, null);
      });
      test('set: 変更が反映されていること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(startDateTime: dateTime);
        viewModel.init(event);
        var expectedTime = TimeOfDay(hour: 12, minute: 20);
        viewModel.startTime = expectedTime;
        expect(viewModel.startTime, expectedTime);
        expect(viewModel.startDateTime, DateTime(2020, 1, 1, 12, 20));
      });
      test('set: 変更が通知されること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(startDateTime: dateTime);
        bool notified = false;
        viewModel.init(event);
        viewModel.addListener(() {
          notified = true;
        });
        viewModel.startTime = TimeOfDay(hour: 12, minute: 20);
        expect(notified, true);
      });
      test('set: nullを渡した場合は変化しないこと', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(startDateTime: dateTime);
        viewModel.init(event);
        viewModel.startTime = null;
        expect(viewModel.startTime, TimeOfDay(hour: 10, minute: 11));
      });
    });

    group('endTime', () {
      test('get: 終了日時の時刻を取得できること', () {
        var expectedDateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(endDateTime: expectedDateTime);
        viewModel.init(event);
        expect(viewModel.endTime, TimeOfDay(hour: 10, minute: 11));
      });
      test('get: 終了日時がnullの場合はnullが返却されること', () {
        var event = CalendarEvent(endDateTime: null);
        viewModel.init(event);
        expect(viewModel.endTime, null);
      });
      test('set: 変更が反映されていること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(endDateTime: dateTime);
        viewModel.init(event);
        var expectedTime = TimeOfDay(hour: 12, minute: 20);
        viewModel.endTime = expectedTime;
        expect(viewModel.endTime, expectedTime);
        expect(viewModel.endDateTime, DateTime(2020, 1, 1, 12, 20));
      });
      test('set: 変更が通知されること', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(endDateTime: dateTime);
        bool notified = false;
        viewModel.init(event);
        viewModel.addListener(() {
          notified = true;
        });
        viewModel.endTime = TimeOfDay(hour: 12, minute: 20);
        expect(notified, true);
      });
      test('set: nullを渡した場合は変化しないこと', () {
        var dateTime = DateTime(2020, 1, 1, 10, 11, 12);
        var event = CalendarEvent(endDateTime: dateTime);
        viewModel.init(event);
        viewModel.endTime = null;
        expect(viewModel.endTime, TimeOfDay(hour: 10, minute: 11));
      });
    });

    group('formatDate', () {
      test('正しくフォーマットされること', () {
        expect(viewModel.formatDate(DateTime(2020, 1, 2)), '2020-01-02');
      });
      test('nullが渡された場合は空文字を返すこと', () {
        expect(viewModel.formatDate(null), '');
      });
    });

    group('formatTime', () {
      test('正しくフォーマットされること', () {
        expect(viewModel.formatTime(TimeOfDay(hour: 1, minute: 2)), '01:02');
      });
      test('nullが渡された場合は空文字を返すこと', () {
        expect(viewModel.formatTime(null), '');
      });
    });

    group('validateName', () {
      Map<String, dynamic> namePatterns = {
        '正常な名前': {'value': 'テスト', 'isValid': true},
        '最大文字数': {'value': '1234567890', 'isValid': true},
        '最大文字数+1': {'value': '12345678901', 'isValid': false},
        '空': {'value': '', 'isValid': false},
        'null': {'value': null, 'isValid': false},
      };

      namePatterns.forEach((String name, dynamic pattern) {
        test(name, () {
          var event = CalendarEvent(name: pattern['value']);
          viewModel.init(event);
          if (pattern['isValid']) {
            expect(viewModel.validateName(), null);
          } else {
            expect(viewModel.validateName().runtimeType, String);
          }
        });
      });
    });

    group('validateStartDateTime', () {
      Map<String, dynamic> namePatterns = {
        '正常な日付': {'value': DateTime(2020, 1, 1, 0, 0, 0), 'isValid': true},
        '無効な日付': {'value': DateTime(2020, 1, 32, 0, 0, 0), 'isValid': true},
        'null': {'value': null, 'isValid': false},
      };

      namePatterns.forEach((String name, dynamic pattern) {
        test(name, () {
          var event = CalendarEvent(startDateTime: pattern['value']);
          viewModel.init(event);
          if (pattern['isValid']) {
            expect(viewModel.validateStartDateTime(), null);
          } else {
            expect(viewModel.validateStartDateTime().runtimeType, String);
          }
        });
      });
    });

    group('updateEvent', () {
      testWidgets('全必須項目入力済の場合、保存できること', (WidgetTester tester) async {
        var event = CalendarEvent(
            id: '111', name: 'test', startDateTime: DateTime(2020, 1, 1));
        viewModel.init(event);
        await tester.pumpWidget(TestForm());
        bool result = await viewModel.updateEvent();
        expect(result, true);
      });
      testWidgets('入力エラーがある場合、保存に失敗すること', (WidgetTester tester) async {
        var event = CalendarEvent(id: '111', name: '', startDateTime: null);
        viewModel.init(event);
        await tester.pumpWidget(TestForm());
        bool result = await viewModel.updateEvent();
        expect(result, false);
      });
    });
  });
}
