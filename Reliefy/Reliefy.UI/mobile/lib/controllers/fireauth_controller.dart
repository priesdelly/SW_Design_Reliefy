import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/pages.dart';

class FireAuthController extends GetxController {
  initialState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.off(Page.login);
      }
    });
  }

  Future<User?> signInUsingEmailPassword({required String email, required String password}) async {
    User? user;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      user = credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          throw ArgumentError.value('No user found for that email.');
        case "invalid-email":
          throw ArgumentError.value('Invalid email.');
        case "wrong-password":
          throw ArgumentError.value('No user found for that email.');
        default:
          throw ArgumentError.value('Invalid credential.');
      }
    }
    return user;
  }

  Future<User?> signInWithGoogle() async {
    User? user;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final result = await FirebaseAuth.instance.signInWithCredential(credential);

      user = result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw ArgumentError.value("Invalid credential.");
      } else if (e.code == 'invalid-credential') {
        throw ArgumentError.value("Invalid credential.");
      }
    }
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
