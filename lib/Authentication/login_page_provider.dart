import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled1/Utilities/firebase_auth.dart';
import 'package:untitled1/Utilities/firebase_user.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class LoginPageProvider with ChangeNotifier {
  int loginStatus = 0;
  String errorMessage = '';
  AuthenticationService get authenticationService => GetIt.instance<AuthenticationService>();
  FirebaseUserService get firebaseUserService => GetIt.instance<FirebaseUserService>();

  var _firebase = FirebaseFirestore.instance;

  void loginUser(BuildContext context, String email, String password) async {
    loginStatus = await authenticationService.signInWithEmail(email, password);
    print(loginStatus);
    if (loginStatus == 0) {
      //@TODO uncomment code when signup is wo rking
      //getting the user information from Firebase Firestore
      var firebaseFirestoreResult = await firebaseUserService.fetchUserData();
      if (firebaseFirestoreResult == null) {
        //user info could not be  fetched
        loginStatus = 3;
      } else {
        Navigator.pushNamed(context, '/mainnav');
      }
      print(firebaseFirestoreResult.toString());

      //  UserModel userModel = Provider.of<UserModel>(context, listen: false);
      //todo create user object
      // userModel.createUserModel(
      //
      // );
    }
    switch (loginStatus) {
      case 1: {
        errorMessage = 'No such user found.';
      }       break;
      case 2: {
        errorMessage = 'Your password is incorrect.';
      } break;
      case 3: {
        errorMessage = 'An error occurred. Please try again';
      } break;
      default: {
        errorMessage = '';
      }
    }
    notifyListeners();
  }
}