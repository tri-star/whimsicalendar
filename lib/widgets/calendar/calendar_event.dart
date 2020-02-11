/// カレンダー上のイベント
class CalendarEvent {
  CalendarEvent(
      {this.name,
      this.startDateTime,
      this.endDateTime = null,
      this.isAllDay = false,
      this.url = '',
      this.description = ''});

  /// イベント名
  String name;

  /// イベントの開始日時
  DateTime startDateTime;

  /// イベントの終了日時
  DateTime endDateTime;

  /// 終日のイベントかどうか
  bool isAllDay;

  /// イベントの関連URL
  String url;

  /// イベントの詳細
  String description;

  DateTime getStartDate() => startDateTime == null
      ? null
      : DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

  DateTime getEndDate() => endDateTime == null
      ? null
      : DateTime(endDateTime.year, endDateTime.month, endDateTime.day);
}
