import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:whimsicalendar/domain/url_sharing/url_sharing_handler_inteface.dart';

/// URLのインテントに関する処理を扱う
class StubUrlSharingHandler extends UrlSharingHandlerInterface {
  String _url;
  UrlSharingCallback _callback;

  /// アプリケーションの起動中に受け取るインテントの処理を行う。
  ///
  /// [callback] : URLが空でなかった場合に実行するコールバック関数
  void subscribe(UrlSharingCallback callback) {
    _callback = callback;
  }

  /// 起動時に受け取ったURLのインテントの内容を返す。
  /// 空の場合はnullを返す
  Future<String> getInitialUrlIntent() async {
    return Future<String>(() {
      return _url;
    });
  }

  @mustCallSuper
  void dispose() {}

  void setUrlForTest(String url) {
    _url = url;
  }

  void sendIntentForTest(String url) {
    _callback(url);
  }
}
