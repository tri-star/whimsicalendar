/// バリデーションエラー1つ分のクラス
class ValidationError {
  /// エラーメッセージ
  final String message;

  /// 識別用のエラーコード
  final String code;

  ValidationError({this.message, this.code = ''});

  @override
  String toString() {
    return message;
  }
}

/// 複数のバリデーションエラーの一覧を保持する
/// 項目別に複数件保持することを想定。
/// 現在のところ、項目内のエラーの表示順は特に考慮していない
class ValidationErrors {
  final Map<String, ValidationError> _errors;

  ValidationErrors() : _errors = {};

  ValidationError add(String key, ValidationError error) {
    return _errors[key] = error;
  }

  ValidationError get(String key) {
    return _errors[key];
  }

  bool has(String key) {
    return _errors.containsKey(key);
  }

  List<String> getAllMessages() {
    return _errors.values.map((e) => e.message).toList();
  }

  String getJoinedMessage(String separator) {
    return _errors.values.map((e) => e.message).join(separator);
  }

  bool isError() {
    return _errors.length > 0;
  }
}
