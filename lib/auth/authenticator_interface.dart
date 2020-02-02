import 'package:whimsicalendar/domain/user/user.dart';

///認証処理を行うクラスのインターフェース
abstract class AuthenticatorInterface {
  /// 認証処理を実行する
  Future<bool> signIn();

  /// ユーザーの認証が済んでいるかどうかを返す
  Future<bool> isAuthenticated();

  /// 認証が済んだユーザーを取得する
  Future<User> getUser();
}

/// 認証関連のエラー
class AuthException implements Exception {
  String message;

  AuthException({this.message});

  String toString() {
    return message;
  }
}
