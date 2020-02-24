import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 日付と時刻のPicker付きの入力欄
class DateTimeInput extends FormField<DateTime> {
  final String label;
  final void Function(DateTime) onDateChanged;
  final void Function(TimeOfDay) onTimeChanged;
  final Future<DateTime> Function(BuildContext, DateTime) onDatePickerPopup;
  final Future<TimeOfDay> Function(BuildContext, TimeOfDay) onTimePickerPopup;

  DateTimeInput(
      {Key key,
      this.label = '',
      initialValue,
      this.onDateChanged = null,
      this.onTimeChanged = null,
      validator = null,
      onSaved = null,
      this.onDatePickerPopup = _showDatePickerPopup,
      this.onTimePickerPopup = _showDateTimePickerPopup})
      : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (FormFieldState<DateTime> field) {
              TimeOfDay initialTime = null;
              if (field.value != null) {
                initialTime = TimeOfDay.fromDateTime(field.value);
              }

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      SizedBox(
                          width: 100, child: Text(label, key: Key('input'))),
                      Icon(Icons.calendar_today),
                      Expanded(
                          child: GestureDetector(
                              onTap: () async {
                                DateTime date = await onDatePickerPopup(
                                    field.context, field.value);
                                field.setValue(date);
                                onDateChanged(date);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: field.hasError
                                                  ? Colors.red
                                                  : Colors.black))),
                                  child: Text(
                                    _formatDate(field.value),
                                    key: Key('input'),
                                    textAlign: TextAlign.right,
                                  )))),
                      Icon(Icons.watch),
                      Expanded(
                          child: GestureDetector(
                              onTap: () async {
                                TimeOfDay time = await onTimePickerPopup(
                                    field.context, initialTime);

                                field.setValue(DateTime(
                                    field.value.year,
                                    field.value.month,
                                    field.value.day,
                                    time.hour,
                                    time.minute));
                                if (onTimeChanged != null) {
                                  onTimeChanged(time);
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: field.hasError
                                                  ? Colors.red
                                                  : Colors.black))),
                                  child: Text(
                                    _formatTime(initialTime),
                                    textAlign: TextAlign.right,
                                  )))),
                    ]),
                    _buildErrorMessage(field)
                  ]);
            });

  /// エラーメッセージを返す
  static Widget _buildErrorMessage(FormFieldState<DateTime> fieldState) {
    if (!fieldState.hasError) {
      return Container();
    }
    return Container(
        padding: EdgeInsets.only(top: 5),
        child: Text(fieldState.errorText, style: TextStyle(color: Colors.red)));
  }

  /// 日付のPickerを表示する
  static Future<DateTime> _showDatePickerPopup(
      BuildContext context, DateTime initialDate) async {
    if (initialDate == null) {
      initialDate = DateTime.now();
    }
    return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 2));
  }

  /// 時刻のPickerを表示する
  static Future<TimeOfDay> _showDateTimePickerPopup(
      BuildContext context, TimeOfDay initialTime) async {
    if (initialTime == null) {
      initialTime = TimeOfDay.now();
    }
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }
}

/// 日付を整形して出力
String _formatDate(DateTime date) {
  if (date == null) {
    return '';
  }
  return DateFormat('y-MM-dd').format(date);
}

/// 時刻を整形して出力
String _formatTime(TimeOfDay time) {
  if (time == null) {
    return '';
  }
  NumberFormat timeFormat = NumberFormat('00');
  return '${timeFormat.format(time.hour)}:${timeFormat.format(time.minute)}';
}
