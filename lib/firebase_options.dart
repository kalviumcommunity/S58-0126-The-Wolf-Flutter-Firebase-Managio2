import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyDC5Zvqx_ZYT4kHvgHFSK-yxYDBWXFRwU0",
      appId: "1:4196720419:web:c4c6063f08bf6afdaab696",
      messagingSenderId: "4196720419",
      projectId: "managio-3f008",
      authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
      storageBucket: "managio-3f008.firebasestorage.app",
      measurementId: "G-SHCB0542W1",
    );
  }
}
