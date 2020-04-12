import 'package:whimsicalendar/auth/authenticator_interface.dart'
    as authenticator_interface;
import 'package:whimsicalendar/domain/user/user.dart';

/// テスト用のAuthenticatorの実装
class StubAuthenticator
    implements authenticator_interface.AuthenticatorInterface {
  User _user;

  /// 認証済のユーザーを返す
  @override
  Future<User> getUser() async {
    return _user;
  }

  /// ユーザーの認証が済んでいるかを返す
  @override
  Future<bool> isAuthenticated() async {
    return Future<bool>(() {
      return (_user != null);
    });
  }

  /// サインインを実行する
  @override
  Future<bool> signIn() async {
    return Future<bool>(() {
      return true;
    });
  }

  void setUserForTest(User user) {
    _user = user;
  }
}
