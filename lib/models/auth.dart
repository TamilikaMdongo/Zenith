import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signupWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (error) {
      print('Error creating new user');
      return null;
    }
  }

  Future<User?> signinWithEmailAndPassword(
      String email, String Password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: Password);
      return userCredential.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
