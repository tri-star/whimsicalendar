import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart'
    as authenticator_interface;
import 'package:whimsicalendar/domain/user/user.dart';

/// Googleアカウントでユーザーを認証し、Userを返す
class GoogleAuthenticator
    implements authenticator_interface.AuthenticatorInterface {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _user;

  GoogleAuthenticator() : _user = null;

  /// 認証済のユーザーを返す
  @override
  Future<User> getUser() async {
    if (_user == null) {
      var firebaseUser = await _firebaseAuth.currentUser();
      if (firebaseUser != null) {
        _user = _createFromFirebaseUser(firebaseUser);
      }
    }
    return _user;
  }

  /// ユーザーの認証が済んでいるかを返す
  @override
  Future<bool> isAuthenticated() async {
    var user = await getUser();
    return (user != null);
  }

  /// サインインを実行する
  @override
  Future<bool> signIn() async {
    FirebaseUser firebaseUser = await _firebaseSignIn();
    if (firebaseUser == null) {
      _user = null;
      return false;
    }
    _user = _createFromFirebaseUser(firebaseUser);
    return true;
  }

  /// Googleアカウントを使用してFirebaseにログインする
  Future<FirebaseUser> _firebaseSignIn() async {
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;
    try {
      // 先にGoogleアカウントでログインする
      if (currentUser == null) {
        currentUser = await _googleSignIn.signInSilently();
      }
      if (currentUser == null) {
        currentUser = await _googleSignIn.signIn();
      }
      if (currentUser == null) {
        return null;
      }

      //ログインしたGoogleアカウントからアクセストークンなどを取得して、
      //そのトークンでFirebaseにログインする。
      GoogleSignInAuthentication googleAuth = await currentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final FirebaseUser firebaseUser =
          (await _firebaseAuth.signInWithCredential(credential)).user;

      return firebaseUser;
    } catch (e) {
      throw new authenticator_interface.AuthException(message: e.toString());
    }
  }

  User _createFromFirebaseUser(FirebaseUser firebaseUser) {
    return User(
        name: '', id: firebaseUser.uid, photoUrl: firebaseUser.photoUrl);
  }
}
