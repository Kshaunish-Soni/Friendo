import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseUserService {
  var _firebase = FirebaseFirestore.instance;

  //adds the user to the firebase firestore 'users' collection
  Future<int> addUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,

  }) async {
    try {
      _firebase
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'id': FirebaseAuth.instance.currentUser!.uid,
      });
      return 0;
    } catch (e) {
      print(e);
      return 1;
    }
  }

  Future<dynamic> fetchUserData() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        var result = await _firebase
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        return result;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}