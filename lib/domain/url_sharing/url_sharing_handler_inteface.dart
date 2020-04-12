typedef UrlSharingCallback = void Function(String url);

abstract class UrlSharingHandlerInterface {
  void subscribe(UrlSharingCallback callback);
}
