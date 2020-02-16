import 'package:firebase_core/firebase_core.dart';
import 'package:whimsicalendar/config/app_config.dart';

class FirebaseAppInitializer {
  Future<FirebaseApp> initialize() {
    return FirebaseApp.configure(
        name: Config.instance.get('firebase.app_name'),
        options: FirebaseOptions(
          googleAppID: Config.instance.get('firebase.google_app_id'),
          gcmSenderID: Config.instance.get('firebase.gcm_sender_id'),
          apiKey: Config.instance.get('firebase.api_key'),
          projectID: Config.instance.get('firebase.project_id'),
        ));
  }
}
