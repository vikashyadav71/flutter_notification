import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'firebase_notification.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final notifications=FirebaseServices();
  @override
  void initState() {
    // TODO: implement initState
    notifications.requestNotification();
    notifications.getDeviceToken();
    notifications.setupInteractMessage(context);

    notifications.fireBaseInit( context);

    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return  Scaffold(appBar:AppBar(
      title: Text('Notification screen',),
    ),);
  }
}
