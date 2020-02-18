import 'package:whimsicalendar/validation/validation.dart';
import 'package:whimsicalendar/widgets/calendar/calendar_event.dart'
    as calendar_widget;

/// カレンダー上のイベント
class CalendarEvent extends calendar_widget.CalendarEvent {
  String id;

  CalendarEvent(
      {this.id,
      String name,
      DateTime startDateTime,
      DateTime endDateTime = null,
      bool isAllDay = false,
      String url = '',
      String description = ''})
      : super(
            name: name = '',
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            isAllDay: isAllDay,
            url: url,
            description: description);

  /// イベント名に関するバリデーション
  List<ValidationError> validateName() {
    List<ValidationError> errors = [];
    if (name.trim().length == 0) {
      errors.add(ValidationError(message: 'イベント名が入力されていません'));
    }
    if (name.trim().length >= 10) {
      errors.add(ValidationError(message: 'イベント名が長すぎます'));
    }
    return errors;
  }

  /// 開始日に関するバリデーション
  List<ValidationError> validateStartDateTime() {
    List<ValidationError> errors = [];
    if (startDateTime == null) {
      errors.add(ValidationError(message: '開始日が指定されていません'));
    }
    return errors;
  }
}
