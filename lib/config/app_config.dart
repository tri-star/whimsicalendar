/// 設定値クラスの規定クラス。環境毎にオーバーライドして利用する
abstract class Config {
  static Config _instance = null;

  Map<String, dynamic> _config;

  /// シングルトンを返す
  static Config get instance {
    if (_instance == null) {
      _instance = _createInstance();
    }

    return _instance;
  }

  static Config _createInstance() {
    return DevelopConfig();
  }

  dynamic get(String key) {
    return _config[key];
  }
}

/// 開発環境用の設定値クラス
class DevelopConfig extends Config {
  DevelopConfig() {
    // 設定情報はシークレットを含む可能性があるがそういった情報の扱い方を調べていないので、
    // 一旦固定のオブジェクトからロードするようにしておく
    _config = _loadFromObject();
  }

  Map<String, dynamic> _loadFromObject() {
    return {
      'firebase.app_name': 'whimsicalendar',
      'firebase.google_app_id':
          '1:1062345543356:ios:36cf6ded0aa2aa977d0ab9',
          // '1:1062345543356:android:a1b99a204be5fbd07d0ab9',
      'firebase.gcm_sender_id': '1062345543356',
      'firebase.api_key': 'AIzaSyAUq9mgv4535dyKyRAt8orsa00hQq1zJC0',
      'firebase.project_id': 'whimsicalendar',
    };
  }
}
