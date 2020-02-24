import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/widgets/date_time_input/date_time_input.dart';

void main() {
  group('DateTimeInput', () {
    group('初期値', () {
      testWidgets('ラベルが正しく表示されていること', (WidgetTester tester) async {
        String labelText = 'テスト用項目名';
        await tester
            .pumpWidget(_wrapDateTimeInput(DateTimeInput(label: labelText)));
        Text label = _getLabel(tester);
        expect(label.data, labelText);
      });

      testWidgets('日付部分は空白であること', (WidgetTester tester) async {
        await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(label: '日時')));
        Text dateInput = _getDateInputFromDateTimeInput(tester);
        expect(dateInput.data, '');
      });

      testWidgets('時刻部分は空白であること', (WidgetTester tester) async {
        await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(label: '日時')));
        Text dateInput = _getTimeInputFromDateTimeInput(tester);
        expect(dateInput.data, '');
      });

      testWidgets('日付を指定した場合、指定した日が表示されること', (WidgetTester tester) async {
        DateTime expectedDate = DateTime(2020, 1, 1);
        await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(
          label: '日時',
          initialValue: expectedDate,
        )));
        Text dateInput = _getDateInputFromDateTimeInput(tester);
        expect(dateInput.data, '2020-01-01');
      });

      testWidgets('時刻を指定した場合、指定した時刻が表示されること', (WidgetTester tester) async {
        DateTime expectedDate = DateTime(2020, 1, 1, 10, 20, 35);
        await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(
          label: '日時',
          initialValue: expectedDate,
        )));
        Text dateInput = _getTimeInputFromDateTimeInput(tester);
        expect(dateInput.data, '10:20');
      });
    });

    group('日付欄タップ時の動作', () {
      testWidgets('日付を選択すると選択した日付がセットされること', (WidgetTester tester) async {
        DateTime selectedDate = null;
        await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(
          label: '日時',
          onDatePickerPopup:
              (BuildContext context, DateTime selectedDate) async {
            return DateTime(2020, 01, 02);
          },
          onDateChanged: (DateTime date) {
            selectedDate = date;
          },
        )));

        Finder finder = _getDateInputFinderFromDateTimeInput(tester);
        await tester.tap(finder);

        expect(selectedDate, DateTime(2020, 01, 02));
      });
    });

    testWidgets('時間を選択すると選択した時間がセットされること', (WidgetTester tester) async {
      TimeOfDay selectedTime = null;
      await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(
        label: '日時',
        initialValue: DateTime(2000, 01, 01, 0, 0),
        onTimePickerPopup: (BuildContext context, TimeOfDay time) async {
          return TimeOfDay(hour: 1, minute: 2);
        },
        onTimeChanged: (TimeOfDay time) {
          selectedTime = time;
        },
      )));

      Finder finder = _getTimeInputFinderFromDateTimeInput(tester);
      await tester.tap(finder);

      expect(selectedTime, TimeOfDay(hour: 1, minute: 2));
    });
  });
}

Widget _wrapDateTimeInput(DateTimeInput dateTimeInput) {
  // TextはDirectionに関するWidgetでラップする必要がある
  return Directionality(textDirection: TextDirection.ltr, child: dateTimeInput);
}

/// 日付入力欄のText部分を返す
Text _getLabel(WidgetTester tester) {
  final Finder inputFinder = find.byType(Text);
  return tester.widget(inputFinder.at(0));
}

/// 日付入力欄のText部分を返す
Text _getDateInputFromDateTimeInput(WidgetTester tester) {
  return tester.widget(_getDateInputFinderFromDateTimeInput(tester));
}

/// 日付入力欄のText部分のFinderを返す
Finder _getDateInputFinderFromDateTimeInput(WidgetTester tester) {
  return find.byType(Text).at(1);
}

/// 時刻入力欄のText部分を返す
Text _getTimeInputFromDateTimeInput(WidgetTester tester) {
  return tester.widget(_getTimeInputFinderFromDateTimeInput(tester));
}

/// 時刻入力欄のText部分のFinderを返す
Finder _getTimeInputFinderFromDateTimeInput(WidgetTester tester) {
  return find.byType(Text).at(2);
}
