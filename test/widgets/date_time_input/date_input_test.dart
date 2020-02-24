import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/widgets/date_time_input/date_input.dart';

void main() {
  group('DateInput', () {
    group('初期値', () {
      testWidgets('ラベルが正しく表示されていること', (WidgetTester tester) async {
        String labelText = 'テスト用項目名';
        await tester.pumpWidget(_wrapDateInput(DateInput(label: labelText)));
        Text label = _getLabel(tester);
        expect(label.data, labelText);
      });

      testWidgets('日付部分は空白であること', (WidgetTester tester) async {
        await tester.pumpWidget(_wrapDateInput(DateInput(label: '日時')));
        Text dateInput = _getDateInputFromDateTimeInput(tester);
        expect(dateInput.data, '');
      });

      testWidgets('日付を指定した場合、指定した日が表示されること', (WidgetTester tester) async {
        DateTime expectedDate = DateTime(2020, 1, 1);
        await tester.pumpWidget(_wrapDateInput(DateInput(
          label: '日時',
          initialValue: expectedDate,
        )));
        Text dateInput = _getDateInputFromDateTimeInput(tester);
        expect(dateInput.data, '2020-01-01');
      });
    });

    group('日付欄タップ時の動作', () {
      testWidgets('日付を選択すると選択した日付がセットされること', (WidgetTester tester) async {
        DateTime selectedDate = null;
        await tester.pumpWidget(_wrapDateInput(DateInput(
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
  });
}

Widget _wrapDateInput(DateInput dateInput) {
  // TextはDirectionに関するWidgetでラップする必要がある
  return Directionality(textDirection: TextDirection.ltr, child: dateInput);
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
