
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled1/Utilities/colors.dart';
import 'package:untitled1/Utilities/size_block.dart';
import 'package:untitled1/Model/userModel.dart';
import 'package:untitled1/Authentication/login_page_provider.dart';
import 'package:untitled1/Utilities/firebase_user.dart';
import 'package:untitled1/Utilities/alert_pop_up_widget.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/Utilities/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:untitled1/main.dart';

import '../Features/Todo.dart';
import '../Utilities/FirebaseUtility.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        shadowColor: Colors.white,
        backgroundColor: CustomColors.blue.withOpacity(0.78),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
        Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeBlock.v! * 50,
                    ),
                    SizedBox(
                      height: SizeBlock.v! * 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(

                        name: 'first name',
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
                            hintText: 'First Name:',
                            alignLabelWithHint: true
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(60),
                        ]),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(

                        name: 'last name',
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
                            hintText: 'Last Name:',
                            alignLabelWithHint: true
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(60),
                        ]),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(

                        name: 'email',
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
                            hintText: 'Email:',
                            alignLabelWithHint: true
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(60),
                        ]),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(

                        name: 'password',
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
                          hintText: 'Password:',
                          alignLabelWithHint: true,

                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(60),
                        ]),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(

                        name: 'confirm password',
                        obscureText: true,
                        decoration: InputDecoration(

                            border: new OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
                            hintText: 'Confirm Password:',
                            alignLabelWithHint: true
                        ),

                        // valueTransformer: (text) => num.tryParse(text),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(60),
                        ]),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    SizedBox(
                      height: SizeBlock.v! * 10,
                    ),
                    SizedBox(
                      child: TextButton(
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )),
                            backgroundColor: MaterialStateProperty.all(
                                CustomColors.blue.withOpacity(0.78))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print(_formKey.currentState!.value);

                            final firstName = _formKey
                                .currentState!.fields['first name']!.value;
                            final lastName =
                                _formKey.currentState!.fields['last name']!.value;
                            final email =
                                _formKey.currentState!.fields['email']!.value;
                            final password = _formKey
                                .currentState!.fields['password']!.value;
                            final confirmPassword =
                                _formKey.currentState!.fields['confirm password']!.value;

                            UserModel um = new UserModel.empty();
                            UserModel.instance.firstName = firstName;
                            UserModel.instance.lastName = lastName;
                            UserModel.instance.email = email;


                            try {
                              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: email,
                                  password: password
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                showAlertPopUp(context, "Error", 'The password provided is too weak.');
                                return;
                              } else if (e.code == 'email-already-in-use') {
                                showAlertPopUp(context, "Error", 'The account already exists for that email');
                                return;
                              }
                            } catch (e) {
                              print(e);
                              return;
                            }
                            FirebaseUtility.addUser(UserModel.instance, context);
                            //successfully verified
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TodoList()));
                          }
                        },
                        child: Text(
                          ' Next ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}