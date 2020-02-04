import 'package:flutter/material.dart';
import 'package:whimsicalendar/widgets/calendar/day_iterator.dart';

/// カレンダーを表示するウィジェット。
/// 日付部分に予定などを複数件表示可能
class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      padding: EdgeInsets.all(3),
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: 0.6,
      children: _buildCalendarGrid(),
    );
  }

  /// カレンダーのグリッド部分を生成する
  List<Widget> _buildCalendarGrid() {
    DateTime baseDate = DateTime.now();
    DayIterator dayIterator = DayIterator(baseDate.year, baseDate.month);

    List<Widget> cells = dayIterator.next().map((DateTime d) {
      return _CalendarCell(activeMonth: baseDate.month, date: d);
    }).toList();

    return cells;
  }
}

/// カレンダーのセル1つ分のウィジェット
class _CalendarCell extends StatelessWidget {
  final int activeMonth;
  final DateTime date;

  _CalendarCell({Key key, this.activeMonth, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String day = '';
    if (date.month == activeMonth) {
      day = date.day.toString();
    }

    return Container(
        padding: EdgeInsets.all(3),
        height: 200,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300], width: 0.5)),
        child: Column(children: [
          Text(day,
              style: TextStyle(
                fontSize: 9,
              )),
          Text(
            '',
            style: TextStyle(
              fontSize: 9,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ]));
  }
}
