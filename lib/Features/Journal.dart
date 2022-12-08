
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:untitled1/Model/DailyModel.dart';
import 'package:untitled1/Utilities/FirebaseUtility.dart';


import 'package:intl/intl.dart';
import 'package:untitled1/Utilities/colors.dart';

import '../Utilities/localFileUtility.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'Friendo Journal Entry';

  @override
  State<JournalPage> createState() => _JournalPage();
}

class _JournalPage extends State<JournalPage> {
  bool _dateHasError = false;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    textBox(String name){
      return Container(
        child: SizedBox(
            height: 100.0,
            child: FormBuilderTextField(
              expands: true,
              maxLines: null,
              minLines: null,
              name: name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: name,
              ),
        // valueTransformer: (text) => num.tryParse(text),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            keyboardType: TextInputType.number,
           ),
        )
      );
    }

    choice(String label){
      return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: FormBuilderChoiceChip<String>(
            backgroundColor: CustomColors.blue,
            selectedColor: Colors.blueAccent[100],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
                labelText:
                label,
            ),
            name: label,
            options: [
              FormBuilderFieldOption(
                value: 'Yes',
              ),
              FormBuilderFieldOption(
                value: 'No',
              ),
            ],
      )
      );
    }
    final _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            child: FormBuilder(
                key: _formKey,

                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: FormBuilderDateTimePicker(
                              name: 'date',
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialValue: DateTime.now(),
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: 'Choose the date',
                              ),

                          ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Text("What a day! Let's talk about.",
                                style: TextStyle(color: Colors.black.withOpacity(1.0),
                                    fontSize: 16),
                                textAlign: TextAlign.center),
                          ),
                          // const Text("What did you do today that made you feel happy?",
                          // textAlign: TextAlign.justify,
                          // ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: textBox("What did you do today? This is your space to talk about absolutely anything!"),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: textBox("What negative emotions did you notice today?"),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: textBox("What positive emotions did you notice today?"),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20,0,20,0),
                            child: Text("How would you describe your overall mood today?",
                              style: TextStyle(color: Colors.black.withOpacity(1.0),
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(100, 20, 20, 100),
                            child: FormBuilderSlider(
                              name: 'how you felt today',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.min(0),
                              ]),
                              min: 0.0,
                              max: 10.0,
                              initialValue: 5.0,
                              divisions: 10,
                              activeColor: Colors.blueAccent,
                              inactiveColor: CustomColors.blue,

                            ),
                          ),
                          choice("Did you do anything to relax today?"),
                          choice("Did you get any excercise today?"),
                          choice("Did you drink alcohol or do drugs today?"),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20,0,20,0),
                            child: Text("How many meals did you eat today?",
                              style: TextStyle(color: Colors.black.withOpacity(1.0),
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(100, 20, 20, 100),
                            child: FormBuilderSlider(
                              name: 'Meals',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.min(0),
                              ]),
                              min: 0.0,
                              max: 6.0,
                              initialValue: 3.0,
                              divisions: 6,
                              activeColor: Colors.blueAccent,
                              inactiveColor: CustomColors.blue,

                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child:Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: const Text(
                                    "Reset",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: MaterialButton(
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                                      var currState = _formKey.currentState!.value;
                                      DailyModel day = DailyModel.fromJson(currState);
                                      var final_json = day.toJson();
                                      print(final_json);
                                      FirebaseUtility.addDay(currState["date"].toString().split(' ')[0], day, context);
                                      //LocalFileUtility.saveFile(final_json);
                                    } else {
                                      print("validation failed");
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ),

                            ],
                          )
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}