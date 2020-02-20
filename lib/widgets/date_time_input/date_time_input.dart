import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 日付と時刻のPicker付きの入力欄
class DateTimeInput extends FormField<DateTime> {
  final String label;
  final DateTime baseDateTime;
  final void Function(DateTime) onDateChanged;
  final void Function(TimeOfDay) onTimeChanged;

  DateTimeInput(
      {Key key,
      this.label = '',
      this.baseDateTime,
      this.onDateChanged = null,
      this.onTimeChanged = null})
      : super(
            initialValue: baseDateTime,
            onSaved: null,
            validator: null,
            builder: (FormFieldState<DateTime> field) {
              TimeOfDay initialTime = null;
              if (baseDateTime != null) {
                initialTime = TimeOfDay.fromDateTime(baseDateTime);
              }

              return Row(children: [
                SizedBox(width: 100, child: Text(label, key: Key('input'))),
                Icon(Icons.calendar_today),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          DateTime date = await _showDatePickerPopup(
                              field.context, baseDateTime);
                          onDateChanged(date);
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black))),
                            child: Text(
                              _formatDate(baseDateTime),
                              key: Key('input'),
                              textAlign: TextAlign.right,
                            )))),
                Icon(Icons.watch),
                Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          TimeOfDay time = await _showDateTimePickerPopup(
                              field.context, initialTime);
                          if (onTimeChanged != null) {
                            onTimeChanged(time);
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black))),
                            child: Text(
                              _formatTime(initialTime),
                              textAlign: TextAlign.right,
                            ))))
              ]);
            });

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
