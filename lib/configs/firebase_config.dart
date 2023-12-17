import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/firebase_options.dart';

class FirebaseConfig {
  static initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}
