import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Features/Calendar.dart';
import 'package:untitled1/Features/Days.dart';
import '../Utilities/NotificationBadge.dart';
import '../Utilities/PushNotificationService.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/Features/Journal.dart';
import 'package:untitled1/Utilities/PushNotificationService.dart';

import '../Utilities/colors.dart';


Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // save data
  late TextEditingController _controller;
  final List<TodoItem> _todoList = <TodoItem>[];
  // text field
  final TextEditingController _textFieldController = TextEditingController();
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  @override
  void initState(){
    //retrieving notifications
    _controller = TextEditingController();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    checkForInitialMessage();
    super.initState();
  }
  //for Handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Parse the message received
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });

      if(_notificationInfo != null){
        showSimpleNotification(
          Text(_notificationInfo!.title!),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(_notificationInfo!.body!),
          background: Colors.cyan.shade700,
          duration: Duration(seconds: 2),
        );
      }
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
      appBar: AppBar(

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                logout();
                Navigator.pop(context); //logout and return to login page
              }),
        ],
        title: Text('Friendo.'),
        backgroundColor: Colors.lightBlueAccent,
      ),

        body: SingleChildScrollView(
              child:
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child:Column(
                    children: [
                      Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 2.0// red as border color
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ), //BorderRadius.all
                  ),
                    child:  Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(100, 20, 20,100),
                            child: SizedBox(
                            height: 200.0,
                            child:
                              ListView(children: _getItems(),),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20,20),
                            child: Center(
                              child: TextField(
                              controller: _controller,
                              expands: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'To-Do',
                              ),
                              onSubmitted: (String value) async {
                                await showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Thanks!'),
                                        content: Text(
                                            'You typed "$value".'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                TodoItem item = TodoItem(_controller.text, false);
                                                _addTodoItem(item);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }
                            )
                          )
                    )
              ],
              )
                      ), _notificationInfo != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )   : Container(),
            ]
        )
        )
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.lightBlueAccent,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          items: <Widget>[
            Icon(Icons.menu, size: 20),
            Icon(Icons.add, size: 20),
            Icon(Icons.list, size: 20),
          ],
          onTap: (index) {
          //Handle button tap
          if(index == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Calendar()));
          }
          else if(index == 1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => JournalPage()));
          }
        },
      ),
    );
    // add items to the to-do list
  }

  void _addTodoItem(TodoItem item) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    setState(() {
      _todoList.add(item);
    });
    _textFieldController.clear();
  }

  void _editTodoItem(TodoItem item){
      _deleteTodoItem(item);
      _displayDialog(context);
  }

  void _deleteTodoItem(TodoItem item){
    setState(() {
      _todoList.remove(item);
    });
    _textFieldController.clear();
  }
  // this Generate list of item widgets
  Widget _buildTodoItem(TodoItem item) {
    return Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  _deleteTodoItem(item);
                });
              },
          child:
         Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
              color: Colors.blueAccent, width: 1.5)),
            ),
          ),
          GestureDetector(
          onTap: () {
            setState(() {
              _editTodoItem(item);
            });
          },
          child: new Text(item.title),
          ),

        ]
    );
  }

  // display a dialog for the user to enter items
  Future<Future> _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  TodoItem item = TodoItem(_textFieldController.text, false);
                  _addTodoItem(item);
                },
              ),
              // Cancel button
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
  // iterates through our todo list title
  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (TodoItem item in _todoList) {
      _todoWidgets.add(_buildTodoItem(item));
    }
    return _todoWidgets;
  }
}

class TodoItem {
  String title = '';
  bool isComplete = false;

  void flipcomplete(){
    this.isComplete = !this.isComplete;
  }

  TodoItem(String title, bool isComplete){
    this.title = title;
    this.isComplete = isComplete;
  }



}


