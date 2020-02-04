import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/widgets/calendar/day_iterator.dart';

import 'calendar_controller.dart';

class CalendarView extends StatefulWidget {
  final CalendarController _controller;

  CalendarView({Key key, CalendarController controller})
      : _controller = controller,
        super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarViewState(_controller);
}

/// カレンダーを表示するウィジェット。
/// 日付部分に予定などを複数件表示可能
class CalendarViewState extends State<CalendarView> {
  final DateTime baseDate;
  CalendarController _controller;

  CalendarViewState(CalendarController controller)
      : baseDate = DateTime.now(),
        _controller = controller;

  @override
  void initState() {
    super.initState();
    if (_controller == null) {
      _controller = new CalendarController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _controller,
        child: Column(children: [
          _buildHeaderSection(),
          Table(
            border: TableBorder.all(color: Colors.grey[900], width: 1),
            children: [..._buildCalendarWeekHeaders(), ..._buildCalendarRows()],
          )
        ]));
  }

  Widget _buildHeaderSection() {
    String dateTitle = '${baseDate.year}年${baseDate.month}月';
    return Container(
        height: 40, padding: EdgeInsets.all(10), child: Text(dateTitle));
  }

  /// カレンダーの曜日部分のヘッダを生成する
  List<TableRow> _buildCalendarWeekHeaders() {
    return [
      TableRow(children: [
        TableCell(child: _CalendarWeekdayCell(weekday: 1)),
        TableCell(child: _CalendarWeekdayCell(weekday: 2)),
        TableCell(child: _CalendarWeekdayCell(weekday: 3)),
        TableCell(child: _CalendarWeekdayCell(weekday: 4)),
        TableCell(child: _CalendarWeekdayCell(weekday: 5)),
        TableCell(child: _CalendarWeekdayCell(weekday: 6)),
        TableCell(child: _CalendarWeekdayCell(weekday: 7)),
      ])
    ];
  }

  /// カレンダーのグリッド部分を生成する
  List<TableRow> _buildCalendarRows() {
    DateTime baseDate = DateTime.now();
    DayIterator dayIterator = DayIterator(baseDate.year, baseDate.month);

    List<TableRow> rows = [];
    List<TableCell> cells = [];
    dayIterator.next().forEach((DateTime day) {
      cells.add(TableCell(
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (_) {
                _controller.selectedDate = day;
              },
              child: _CalendarCell(activeMonth: baseDate.month, date: day))));
      if (cells.length == 7) {
        rows.add(TableRow(
            children: cells,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey[200]))));
        cells = [];
      }
    });

    return rows;
  }
}

///カレンダーの曜日部分のセル1つ分のウィジェット
class _CalendarWeekdayCell extends StatelessWidget {
  final weekday;

  _CalendarWeekdayCell({Key key, this.weekday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<int, String> weekdayMap = {
      7: '日',
      1: '月',
      2: '火',
      3: '水',
      4: '木',
      5: '金',
      6: '土',
    };

    return Container(
        height: 25,
        alignment: Alignment.center,
        child: Text(
          weekdayMap[weekday],
          style: TextStyle(fontSize: 10),
        ));
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
        padding: EdgeInsets.all(5),
        height: 80,
        alignment: Alignment.centerLeft,
        child: Column(children: [
          Text(day,
              style: TextStyle(
                fontSize: 10,
              )),
          Text(
            _getActiveMessage(
                Provider.of<CalendarController>(context).selectedDate),
            style: TextStyle(
              fontSize: 9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ]));
  }

  String _getActiveMessage(DateTime selectedDate) {
    if (selectedDate == date) {
      return '選択中';
    }
    return '-';
  }
}
