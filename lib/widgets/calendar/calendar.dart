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
  DateTime baseDate;
  CalendarController _controller;

  CalendarViewState(CalendarController controller)
      : baseDate = null,
        _controller = controller;

  @override
  void initState() {
    super.initState();
    if (_controller == null) {
      _controller = new CalendarController();
    }
    baseDate = _controller.currentMonth;
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
        child: Consumer(builder: (BuildContext context,
            CalendarController controller, Widget child) {
          return GestureDetector(
              onHorizontalDragEnd: (DragEndDetails detail) {
                print(detail.velocity.pixelsPerSecond.dx);
                if (detail.velocity.pixelsPerSecond.dx > 0) {
                  _controller.goToPrevMonth();
                } else if (detail.velocity.pixelsPerSecond.dx < 0) {
                  _controller.goToNextMonth();
                }
              },
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 350),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    Offset beginOffset;
                    Offset endOffset;

                    //前の月にスクロール
                    if (child.key != ValueKey(_controller.currentMonth)) {
                      beginOffset = Offset(1.0, 0.0);
                      endOffset = Offset(0.0, 0.0);
                    } else {
                      beginOffset = Offset(-1.0, 0.0);
                      endOffset = Offset(0.0, 0.0);
                    }

                    if (_controller.scrollDirection == -1) {
                      beginOffset = beginOffset.scale(-1, 0);
                      endOffset = endOffset.scale(-1, 0);
                    }

                    final inAnimation =
                        Tween<Offset>(begin: beginOffset, end: endOffset)
                            .animate(animation);

                    return SlideTransition(position: inAnimation, child: child);
                  },
                  child: Column(
                      key: ValueKey<DateTime>(_controller.currentMonth),
                      children: [
                        _buildHeaderSection(),
                        Table(
                          border: TableBorder.all(
                              color: Colors.grey[900], width: 1),
                          children: [
                            ..._buildCalendarWeekHeaders(),
                            ..._buildCalendarRows()
                          ],
                        )
                      ])));
        }));
  }

  Widget _buildHeaderSection() {
    String dateTitle =
        '${_controller.currentMonth.year}年${_controller.currentMonth.month}月';
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
    DayIterator dayIterator = DayIterator(
        _controller.currentMonth.year, _controller.currentMonth.month);

    List<TableRow> rows = [];
    List<TableCell> cells = [];
    dayIterator.next().forEach((DateTime day) {
      cells.add(TableCell(
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (_) {
                _controller.selectedDate = day;
              },
              child: _CalendarCell(
                  activeMonth: _controller.currentMonth.month, date: day))));
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
      1: '日',
      2: '月',
      3: '火',
      4: '水',
      5: '木',
      6: '金',
      7: '土',
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
        decoration: _getContainerDecoration(
            Provider.of<CalendarController>(context).selectedDate),
        height: 80,
        alignment: Alignment.centerLeft,
        child: Column(children: [
          Text(day,
              style: TextStyle(
                fontSize: 10,
              )),
          Text(
            '',
            style: TextStyle(
              fontSize: 9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ]));
  }

  BoxDecoration _getContainerDecoration(DateTime selectedDate) {
    if (selectedDate == date) {
      return BoxDecoration(
        color: Color.fromARGB(20, 0, 0, 0),
      );
    }
    return BoxDecoration();
  }
}
