import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/providers/user_provider.dart';
import '../utils/routes.dart';
import '../models/user.dart' as u;

class FireAuthController extends GetxController {
  final UserProvider userController = Get.find();

  initialState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAllNamed(PageRoutes.login);
      }
    });
  }

  String? getUid() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<u.User?> signInUsingEmailPassword({required String email, required String password}) async {
    u.User? user;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      user = await userController.createUser(uid: credential.user!.uid, email: credential.user!.email!, signInType: "signInWithEmailAndPassword");
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

  Future<u.User?> signInWithGoogle() async {
    u.User? user;
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
      user = await userController.createUser(uid: result.user!.uid, email: result.user!.email!, signInType: credential.signInMethod);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw ArgumentError.value("Account already exist.");
      } else if (e.code == 'invalid-credential') {
        throw ArgumentError.value("Invalid credential.");
      }
    }
    return user;
  }

  Future<u.User?> signUp({required String email, required String password}) async {
    u.User? user;
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      user = await userController.createUser(uid: result.user!.uid, email: result.user!.email!, signInType: "signInWithEmailAndPassword");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak-password":
          throw ArgumentError.value("Weak password.");
        case "email-already-in-use":
          throw ArgumentError.value("Email already in use.");
        case "invalid-email":
          throw ArgumentError.value("Invalid Email.");
        default:
          throw ArgumentError.value('Invalid credential.');
      }
    }
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
