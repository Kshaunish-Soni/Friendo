import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/Authentication/login_page.dart';
import 'Features/Todo.dart';
import 'utilities/firebase_auth.dart';
import 'utilities/firebase_user.dart';
import 'package:untitled1/Model/userModel.dart';
import 'package:untitled1/Utilities/size_block.dart';
import 'package:untitled1/Authentication/login_page_provider.dart';


void setupLocator() {
  final locator = GetIt.instance;
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirebaseUserService());
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDESjDo7vGWwziP8suENUGfcW--DOOR4pI",
      appId: "1:611089728731:android:db0f3e18af440c66fc78fe",
      messagingSenderId: "XXX",
      projectId: "friendo-journal",
    ),
  );

 setupLocator();
  //checking if the user is logged in or not and navigating to the appropriate page accordingly
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState(true);
}


class _MyAppState extends State<MyApp> {
  bool isUserAuthorized;
  _MyAppState(this.isUserAuthorized);
  late StreamSubscription<User?> user;

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
    // the rest of your build method



  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MultiProvider(

          providers: [
            ChangeNotifierProvider<LoginPageProvider>(
              create: (BuildContext context) => LoginPageProvider(),
            ),
            ChangeNotifierProvider<UserModel>(
              create: (BuildContext context) => UserModel(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner:false,
            supportedLocales: [
              Locale('en','US'),
            ],
            localizationsDelegates: [
              FormBuilderLocalizations.delegate,
            ],
            builder: (BuildContext context, Widget? child) { //????
              SizeBlock().init(context);
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                  child: child!);
            },
            initialRoute: FirebaseAuth.instance.currentUser == null ? '/login': '/mainnav',

            routes: {
              '/mainnav': (context) => TodoList(),
              '/login' : (context) => LoginScreen(),
            },
          ),
        )
    );
  }


}


