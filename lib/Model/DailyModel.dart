
import 'dart:core';
import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/Utilities/Date.dart';
import 'package:intl/intl.dart';

class DailyModel with ChangeNotifier{
  late String date;
  Map<String,dynamic> userMap = {
    "date": '',
    "What did you do today? This is your space to talk about absolutely anything!": '',
    "What negative emotions did you notice today?": '',
    "What positive emotions did you notice today?": '',
    "how you felt today": 0,
    "Did you do anything to relax today?": '',
    "Did you get any excercise today?": '',
    "Did you drink alcohol or do drugs today?": '',
    "Meals": 0,
  };



  DailyModel.fromJson(Map<String, dynamic> json) {
    for(String k in userMap.keys){
      userMap[k] = json[k].toString();
    }

  }

  Map<String, Object?> toJson() {
    Map<String, Object?> requestBody = {};
    for (String k in this.userMap.keys) {
      requestBody[k] = this.userMap[k];
    }
    return requestBody;
  }
}
