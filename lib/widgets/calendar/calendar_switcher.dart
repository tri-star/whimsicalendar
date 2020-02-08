import 'package:flutter/material.dart';

import 'calendar_controller.dart';

/// カレンダーの月を切り替えるアニメーションに関する処理
class CalendarSwitcher {
  static Widget buildAnimatedSwitcher(
      {CalendarController controller, Widget child}) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 350),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          Offset beginOffset;
          Offset endOffset;

          // この関数で"これから非表示になるカレンダー(A)"と"これから表示されるカレンダー(B)"の両方を処理するので、
          // 今処理しているのがどちらのカレンダーかをValuKeyで判定する
          // (A)の方はOffsetで指定した向きと逆方向で再生されるのでその点の考慮が必要
          if (child.key != ValueKey(controller.currentMonth)) {
            beginOffset = Offset(1.0, 0.0);
            endOffset = Offset(0.0, 0.0);
          } else {
            beginOffset = Offset(-1.0, 0.0);
            endOffset = Offset(0.0, 0.0);
          }

          // スクロールの方向に応じてOffsetを逆転させる
          if (controller.scrollDirection == -1) {
            beginOffset = beginOffset.scale(-1, 0);
            endOffset = endOffset.scale(-1, 0);
          }

          final positionAnimation =
              Tween<Offset>(begin: beginOffset, end: endOffset)
                  .animate(animation);

          return SlideTransition(position: positionAnimation, child: child);
        },
        child: child);
  }
}
