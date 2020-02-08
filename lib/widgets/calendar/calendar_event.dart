/// カレンダー上のイベント
class CalendarEvent {
  CalendarEvent(
      {this.name,
      DateTime startDateTime,
      DateTime endDateTime = null,
      this.isAllDay = false,
      this.url = '',
      this.description = ''})
      : _startDateTime = startDateTime,
        _endDateTime = endDateTime;

  /// イベント名
  String name;

  /// イベントの開始日時
  DateTime _startDateTime;

  /// イベントの終了日時
  DateTime _endDateTime;

  /// 終日のイベントかどうか
  bool isAllDay;

  /// イベントの関連URL
  String url;

  /// イベントの詳細
  String description;

  DateTime getStartDate() =>
      DateTime(_startDateTime.year, _startDateTime.month, _startDateTime.day);

  DateTime getEndDate() =>
      DateTime(_endDateTime.year, _endDateTime.month, _endDateTime.day);

  DateTime getStartTime() => DateTime(0, 0, 0, _startDateTime.hour,
      _startDateTime.minute, _startDateTime.second);

  DateTime getEndTime() => DateTime(
      0, 0, 0, _endDateTime.hour, _endDateTime.minute, _endDateTime.second);
}
