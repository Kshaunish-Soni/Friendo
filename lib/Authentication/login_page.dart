
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:untitled1/Utilities/size_block.dart';
import 'package:untitled1/Authentication/login_page_provider.dart';
import 'package:untitled1/Authentication/reset_password_page.dart';
import 'package:untitled1/Authentication/signup_page.dart';
import 'package:untitled1/Utilities/alert_pop_up_widget.dart';
import 'package:untitled1/Utilities/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Features/Todo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  LoginPageProvider? loginPageProvider;

  @override
  void initState() {
    loginPageProvider = Provider.of<LoginPageProvider>(context, listen: false);
    loginPageProvider!.addListener(() {
      if (loginPageProvider!.loginStatus > 0) {
        print("error\n\n");
        showAlertPopUp(
            context, "Error Occurred", loginPageProvider!.errorMessage);
      } else {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        /*appBar: AppBar(
          title: Center(
              child: Text(
            'Login',
            style: TextStyle(color: Colors.black),
          )),
          backgroundColor: Colors.white,
        ),*/
        body:
       Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeBlock.v!*120,),
                // Image.asset('assets/NKF-Logo-removebg-preview.png'),
                SizedBox(height: SizeBlock.v!*10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 65),
                      child: Column(
                        children: [
                          Container(
                              child: TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Username:'),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 15)
                          ),
                          SizedBox(height: SizeBlock.v!*10,),
                          Container(
                              child: TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Password:'),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 15)
                          ),
                        ],
                      ),

                    ),
                    SizedBox(height: SizeBlock.v!*50,),
                    SizedBox(
                      height: SizeBlock.v!*38,
                      width: SizeBlock.h!*105,
                      child: TextButton(
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            backgroundColor:
                            MaterialStateProperty.all(CustomColors.blue.withOpacity(0.78))),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _usernameController.text,
                              password: _passwordController.text,
                            );

                            Navigator.push(context, MaterialPageRoute(builder: (context) => TodoList()));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found' || e.code == 'invalid-email') {
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                            } else {
                              print(e.code);
                            }
                          }

                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeBlock.v!*15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));

                          },
                          child: Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeBlock.v!*70,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                          ),
                        ),
                        Text(
                          '  Don\'t have an account?  ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeBlock.v!*45,),
                    SizedBox(
                      height: SizeBlock.v!*38,
                      width: SizeBlock.h!*200,
                      child: TextButton(
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            backgroundColor:
                            MaterialStateProperty.all(CustomColors.blue.withOpacity(0.78))),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                        },
                        child: Text(
                          '  Create an account  ',
                          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
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
