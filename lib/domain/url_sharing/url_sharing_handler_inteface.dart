typedef UrlSharingCallback = void Function(String url);

/// URLのインテントに関する処理を扱う
abstract class UrlSharingHandlerInterface {
  /// アプリケーションの起動中に受け取るインテントの処理を行う。
  ///
  /// [callback] : URLが空でなかった場合に実行するコールバック関数
  void subscribe(UrlSharingCallback callback);

  /// 起動時に受け取ったURLのインテントの内容を返す
  /// 空の場合はnullを返す
  Future<String> getInitialUrlIntent();
}
