import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/widgets/date_time_input/date_time_input.dart';

void main() {
  group('DateTimeInput', () {
    testWidgets('初期値: ラベルが正しく表示されていること', (WidgetTester tester) async {
      String labelText = 'テスト用項目名';
      await tester
          .pumpWidget(_wrapDateTimeInput(DateTimeInput(label: labelText)));
      Text label = _getLabel(tester);
      expect(label.data, labelText);
    });

    testWidgets('初期値: 日付部分は空白であること', (WidgetTester tester) async {
      await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(label: '日時')));
      Text dateInput = _getDateInputFromDateTimeInput(tester);
      expect(dateInput.data, '');
    });

    testWidgets('初期値: 時刻部分は空白であること', (WidgetTester tester) async {
      await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(label: '日時')));
      Text dateInput = _getTimeInputFromDateTimeInput(tester);
      expect(dateInput.data, '');
    });

    testWidgets('初期値: 日付を指定した場合、指定した日が表示されること', (WidgetTester tester) async {
      DateTime expectedDate = DateTime(2020, 1, 1);
      await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(
        label: '日時',
        baseDateTime: expectedDate,
      )));
      Text dateInput = _getDateInputFromDateTimeInput(tester);
      expect(dateInput.data, '2020-01-01');
    });

    testWidgets('初期値: 時刻を指定した場合、指定した時刻が表示されること', (WidgetTester tester) async {
      DateTime expectedDate = DateTime(2020, 1, 1, 10, 20, 35);
      await tester.pumpWidget(_wrapDateTimeInput(DateTimeInput(
        label: '日時',
        baseDateTime: expectedDate,
      )));
      Text dateInput = _getTimeInputFromDateTimeInput(tester);
      expect(dateInput.data, '10:20');
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
  final Finder inputFinder = find.byType(Text);
  return tester.widget(inputFinder.at(1));
}

/// 時刻入力欄のText部分を返す
Text _getTimeInputFromDateTimeInput(WidgetTester tester) {
  final Finder inputFinder = find.byType(Text);
  return tester.widget(inputFinder.at(2));
}
