import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled1/Model/DailyModel.dart';
import 'package:untitled1/Model/userModel.dart';
import 'package:untitled1/Utilities/alert_pop_up_widget.dart';
import 'package:intl/intl.dart';

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
late String date = formatter.format(now);

class FirebaseUtility {


  static  final userRef = FirebaseFirestore.instance.collection('user').withConverter<UserModel>(
    fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
    toFirestore: (userModel, _) => userModel.toJson(),
  );
  static  final dayRef = FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).collection("days").withConverter<DailyModel>(
    fromFirestore: (snapshot, _) => DailyModel.fromJson(snapshot.data()!),
    toFirestore: (dayModel, _) => dayModel.toJson(),
  );

  static void addUser(UserModel userModel, BuildContext context) async {
    print(userModel);
    await userRef.doc(FirebaseAuth.instance.currentUser!.uid).set(userModel).then((value) => showAlertPopUpAuth(context, "Success", "Your account has been successfully created!"))
        .catchError((error) { //print("Failed to add user: $error   \n Stacktrace:${StackTrace.current}");
      showAlertPopUp(context, "Error", "Could not add user. Please check your connection or try again later");});

  }
  static void addDay(String date,DailyModel dayModel, BuildContext context) async {
    //set overwrites anything already within the document. Works for new day and updating
    //when updating you must set entire day model
    await dayRef.doc(date).set(dayModel) .then((value) => print("Day Added"))
        .catchError((error) { print("Failed to add day: $error"); showAlertPopUp(context, "Error", "Could not add add. Please check your connection or try again later");});

  }
  static void updateSpecificFieldsInDay(String date,DailyModel dayModel, BuildContext context) async {
//only updates fields passed through with dayModel
    //Example: if calories burned is the only field in @param dayModel, then it will be the only one updated
    await dayRef.doc(date).set(dayModel,SetOptions(merge: true)) .then((value) => print("Day Added"))
        .catchError((error) { print("Failed to add day: $error"); showAlertPopUp(context, "Error", "Could not add add. Please check your connection or try again later");});

  }
  static void updateSpecificFieldsUser(String date,UserModel userModel, BuildContext context) async {
//only updates fields passed through with dayModel
    //Example: if calories burned is the only field in @param dayModel, then it will be the only one updated
    await userRef.doc(FirebaseAuth.instance.currentUser!.uid).set(userModel,SetOptions(merge: true)) .then((value) => print("UserModel Added"))
        .catchError((error) { print("Failed to add User: $error"); showAlertPopUp(context, "Error", "Could not add add. Please check your connection or try again later");});

  }

  static void getDays(int numDays) async {
    final recentPostsRef = FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).collection('days').limitToLast(numDays);
  }

}