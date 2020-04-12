import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:whimsicalendar/domain/url_sharing/url_sharing_handler_inteface.dart';

/// URLのインテントに関する処理を扱う
class UrlSharingHandler extends UrlSharingHandlerInterface {
  StreamSubscription _subscription;

  /// アプリケーションの起動中に受け取るインテントの処理を行う。
  ///
  /// [callback] : URLが空でなかった場合に実行するコールバック関数
  void subscribe(UrlSharingCallback callback) {
    _subscription = ReceiveSharingIntent.getTextStream().listen((String url) {
      if (url == '') {
        return;
      }
      callback(url);
    });
  }

  @mustCallSuper
  void dispose() {
    _subscription.cancel();
  }
}
