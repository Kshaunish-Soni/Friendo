import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/Model/DailyModel.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/Utilities/Date.dart';

class DaysInformation extends StatefulWidget {
  late String datetime;
  @override
  _DayInformationState createState() => _DayInformationState();
  DaysInformation(String datetime){
    this.datetime = datetime;
  }

}

class _DayInformationState extends State<DaysInformation> {


  @override
  void initstate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Past Journal Entries"),
      ),
      body:
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('user')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("days")
                  .doc(widget.datetime)
                  .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if(snapshot.hasData) {
                DailyModel dailymodel = DailyModel.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);
                JournalContent content = JournalContent(dailymodel);
                return content;
              } else{
                return Scaffold(
                    appBar: AppBar(
                      title: Text(""),
                      backgroundColor: Colors.blueAccent,
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Loading...'),
                          )
                        ],
                      ),
                    )
                );
              }
        },
      )
    );
  }
}

class JournalContent extends StatefulWidget{
  late DailyModel dailyModel;

  JournalContent(DailyModel dailyModel){
    this.dailyModel = dailyModel;
  }
  @override
  _JournalContentState createState() => _JournalContentState();
}

class _JournalContentState extends State<JournalContent>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("What did you do today?\n"),
        SizedBox(
          height: 100,
          width: 100,
          child: Text(widget.dailyModel.userMap["What did you do today? This is your space to talk about absolutely anything!"]!.toString()),
        ),
        Text("What negative emotions did you notice today?\n"),
        SizedBox(
          height: 100,
          width: 100,
          child: Text(widget.dailyModel.userMap["What negative emotions did you notice today?"]!.toString()),
        ),
        Text("What positive emotions did you notice today?\n"),
        SizedBox(
          height: 100,
          width: 100,
          child: Text(widget.dailyModel.userMap["What positive emotions did you notice today?"]!.toString()),
        ),
        Text("how did you feel today?\n"),
        SizedBox(
          height: 100,
          width: 100,
          child: Text(widget.dailyModel.userMap["how you felt today"]!.toString()),
        ),
        Text("Did you do anything to relax today?\n"),
        SizedBox(
            height: 100,
            width: 100,
            child: Text(widget.dailyModel.userMap["Did you do anything to relax today?"]!.toString()),
        ),
        Text("Did you get any excercise today?\n"),
        SizedBox(
          height: 100,
          width: 100,
          child: Text(widget.dailyModel.userMap["Did you get any excercise today?"]!.toString()),
        ),
        Text("Did you drink alcohol or do drugs today?\n"),
        SizedBox(
          height: 100,
          width: 100,
          child: Text(widget.dailyModel.userMap["Did you drink alcohol or do drugs today?"]!.toString()),
        ),
        Text("How many meals did you have today?\n"),
        SizedBox(
          height: 100,
          width: 100,
          child: Text(widget.dailyModel.userMap["Meals"]!.toString()),
        ),
      ],
    );
  }
}


