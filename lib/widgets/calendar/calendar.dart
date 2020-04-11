import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/widgets/calendar/day_iterator.dart';

import 'calendar_controller.dart';
import 'calendar_event.dart';
import 'calendar_switcher.dart';

/// カレンダーを表示するウィジェット。
/// 日付部分に予定などを複数件表示可能
class CalendarView extends StatefulWidget {
  final CalendarController _controller;

  CalendarView({Key key, CalendarController controller})
      : _controller = controller,
        super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarViewState(_controller);
}

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
      _controller = new CalendarController<CalendarEvent>();
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
              onHorizontalDragEnd: _onHorizontalSwipeEnd,
              child: CalendarSwitcher.buildAnimatedSwitcher(
                  controller: controller,
                  child: Column(
                      // AnimatedSwitcherが要素を識別するためにKeyが必要
                      key: ValueKey<DateTime>(controller.currentMonth),
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

  /// カレンダーのヘッダ(年月)を生成する
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
      cells.add(_buildCalendarDayCell(context: context, date: day));
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

  /// 日付部分のセル1つ分を生成する
  TableCell _buildCalendarDayCell({BuildContext context, DateTime date}) {
    String day = '';
    if (date.month == _controller.currentMonth.month) {
      day = date.day.toString();
    }

    return TableCell(
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (_) {
              _controller.selectedDate = date;
            },
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: _getContainerDecoration(
                    _controller.selectedDate == date, date.weekday),
                height: 80,
                alignment: Alignment.centerLeft,
                child: Column(children: [
                  Text(day,
                      style: TextStyle(
                        fontSize: 10,
                      )),
                  _buildEventList(date),
                ]))));
  }

  Widget _buildEventList(DateTime date) {
    List<CalendarEvent> events = _controller.getEventsOn(date);
    if (events == null || events.length == 0) {
      return Container();
    }

    List<Widget> eventTitleList = [];
    events.forEach((CalendarEvent e) {
      eventTitleList.add(Container(
          margin: EdgeInsets.only(bottom: 5),
          color: Colors.green[200],
          child: Text(e.name,
              overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9))));
    });

    return Container(child: Column(children: eventTitleList));
  }

  BoxDecoration _getContainerDecoration(bool isActive, int weekday) {
    Color backgroundColor = Colors.white;
    if (weekday == 6) {
      backgroundColor = Colors.blue[100];
    } else if (weekday == 7) {
      backgroundColor = Colors.red[100];
    }

    if (isActive) {
      backgroundColor =
          Color.alphaBlend(Color.fromARGB(30, 0, 0, 0), backgroundColor);
    }
    return BoxDecoration(color: backgroundColor);
  }

  /// 横方向のスワイプが行われた場合の処理
  void _onHorizontalSwipeEnd(DragEndDetails detail) {
    if (detail.velocity.pixelsPerSecond.dx > 100) {
      _controller.goToPrevMonth();
    } else if (detail.velocity.pixelsPerSecond.dx < -100) {
      _controller.goToNextMonth();
    }
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

    Color dayColor = Colors.white;
    if (this.weekday == 7) {
      dayColor = Colors.blue[100];
    } else if (this.weekday == 1) {
      dayColor = Colors.red[100];
    }

    return Container(
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: dayColor),
        child: Text(
          weekdayMap[weekday],
          style: TextStyle(fontSize: 10),
        ));
  }
}
