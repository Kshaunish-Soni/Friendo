import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:untitled1/Utilities/colors.dart';
import 'package:untitled1/Utilities/size_block.dart';
import 'package:untitled1/Utilities/alert_pop_up_widget.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeBlock.h! * 15),
            child: Column(
              children: [
                SizedBox(height: SizeBlock.v! * 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: CustomColors.orange,
                          size: SizeBlock.v! * 30,
                        )),
                  ],
                ),
                SizedBox(height: SizeBlock.v! * 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      physics: ClampingScrollPhysics(
                          parent: NeverScrollableScrollPhysics()),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeBlock.h! * 35.0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Enter your email',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: SizeBlock.v! * 35),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  Container(
                                      child:
                                      FormBuilder(
                                        key: _formKey,
                                        child: FormBuilderTextField(
                                          name: 'reset',
                                          decoration: InputDecoration(
                                            labelText: 'Email:',
                                          ),

                                          // valueTransformer: (text) => num.tryParse(text),
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.maxLength(60),
                                          ]),
                                          keyboardType: TextInputType.emailAddress,
                                        ),
                                      )
                                  ),
                                  SizedBox(height: SizeBlock.v! * 35),
                                  SizedBox(
                                    height: SizeBlock.v! * 38,
                                    width: SizeBlock.h! * 150,
                                    child: TextButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              )),
                                          backgroundColor:
                                          MaterialStateProperty.all(
                                              CustomColors.orange
                                                  .withOpacity(0.78))),
                                      onPressed: () async {
                                        _formKey.currentState!.save();
                                        if(_formKey.currentState!.validate()) {
                                          //sending password reset email if form is valid
                                          FirebaseAuth _firebaseAuth = FirebaseAuth
                                              .instance;
                                          await _firebaseAuth
                                              .sendPasswordResetEmail(
                                              email: _formKey.currentState!.fields['reset']!.value).whenComplete(() {
                                            showAlertPopUp(context, "Success", "Password Email sent");

                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                          }); }
                                      },
                                      child: Text(
                                        ' Reset Password  ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
