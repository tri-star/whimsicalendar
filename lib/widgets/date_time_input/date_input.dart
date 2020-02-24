import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 日付のPicker付きの入力欄
class DateInput extends FormField<DateTime> {
  final String label;
  final void Function(DateTime) onDateChanged;
  final Future<DateTime> Function(BuildContext, DateTime) onDatePickerPopup;

  /// 表示している値はFormFieldStateで管理されるが、
  /// この値を外部から操作したいケースがあるため外部から受け取れるようにする。
  /// 今の実装ではFormFieldState.resetが呼び出された時、onDateChanged等を呼び出す仕組みが実装されていないので不完全。
  /// (正しく実装するとTextFormFieldとTextEditingControllerのようになると思われる)
  final FormFieldState<DateTime> state;

  DateInput(
      {Key key,
      this.label = '',
      initialValue,
      this.onDateChanged = null,
      validator = null,
      onSaved = null,
      this.onDatePickerPopup = _showDatePickerPopup,
      this.state})
      : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (FormFieldState<DateTime> field) {
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
                    ]),
                    _buildErrorMessage(field)
                  ]);
            });

  @override
  FormFieldState<DateTime> createState() => state ?? super.createState();

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
}

/// 日付を整形して出力
String _formatDate(DateTime date) {
  if (date == null) {
    return '';
  }
  return DateFormat('y-MM-dd').format(date);
}
