import 'package:flutter/material.dart';

/// ラベル付きのチェックボックス
class LabeledCheckBox extends StatelessWidget {
  /// ラベル部分に表示するウィジェット
  final Widget child;

  /// 変更があった場合に通知されるコールバック。
  /// 標準のCheckboxと異なり、変更があった要素のvalueが通知される
  final void Function(bool) onChanged;

  /// このチェックボックスが持つチェック状態
  final bool checked;

  const LabeledCheckBox(
      {Key key,
      @required this.child,
      @required this.onChanged,
      this.checked = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
        value: checked,
        onChanged: (value) => onChanged(value),
      ),
      GestureDetector(
          onTap: () {
            onChanged(!checked);
          },
          child: child)
    ]);
  }
}
