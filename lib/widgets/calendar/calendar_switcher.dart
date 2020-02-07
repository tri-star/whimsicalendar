import 'package:flutter/material.dart';

import 'calendar_controller.dart';

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

          //前の月にスクロール
          if (child.key != ValueKey(controller.currentMonth)) {
            beginOffset = Offset(1.0, 0.0);
            endOffset = Offset(0.0, 0.0);
          } else {
            beginOffset = Offset(-1.0, 0.0);
            endOffset = Offset(0.0, 0.0);
          }

          if (controller.scrollDirection == -1) {
            beginOffset = beginOffset.scale(-1, 0);
            endOffset = endOffset.scale(-1, 0);
          }

          final inAnimation = Tween<Offset>(begin: beginOffset, end: endOffset)
              .animate(animation);

          return SlideTransition(position: inAnimation, child: child);
        },
        child: child);
  }
}
