import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //returns 1 if user not found, 2 if password is incorrect, 3 if some error occurred | 0 if success
  Future<int> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 0;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        print('No user found for that email.');
        return 1;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 2;
      } else {
        print(e.code);
        return 3;
      }
    }
  }

  //returns 1 if password is weak, 2 is email is already in use, 3 if any error occurred | 0 if success
  Future<int> signUpWithEmail(String email, String password) async {
    try {
      print('signing up');
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("sign up auth is 0");
      return 0;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print(e);
        return 1;
      } else if (e.code == 'email-already-in-use') {
        print(e);
        return 2;
      } else {
        return 3;
      }
    } catch (e) {
      print(e);
      return 3;
    }
  }

  //returns 1 if user not found, 2 if any error occurred | 0 if success
  Future<int> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 0;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        print('E-mail not found.');
        return 1;
      } else {
        return 2;
      }
    } catch (e) {
      print(e);
      return 3;
    }
  }

  //returns 1 on any error | 0 on success
  Future<int> signOut() async {
    try {
      await _auth.signOut();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.clear();
      return 0;
    } on FirebaseAuthException catch (e) {
      return 1;
    }
  }
}
