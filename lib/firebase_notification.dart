

import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'eventscreen.dart';

class FirebaseServices{
  final messaging=FirebaseMessaging.instance;
  final _flutterNotificationPlugin=FlutterLocalNotificationsPlugin();//sab mahnat andorid ke liye ios apne aap kr leta hai uske liye easy  hai
  void requestNotification()async{
    final settings=await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true

    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      if (kDebugMode) {
        print('user Granted permission');
      }

    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){

      if (kDebugMode) {
        print('cancelled the request by user');
      }
    }
  }//phle permission le li gai hai yaha
  Future<String> getDeviceToken()async{
    String ?token=await messaging.getToken();
    if (kDebugMode) {
      print(token);
    }
    return token!;
  }//token may expire and notification work on device  token not id
  void initLocalNotifications(BuildContext context,  RemoteMessage message)async{
    var androidInitializationSettings=const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings=const DarwinInitializationSettings();
    var initializationSettings=InitializationSettings(android: androidInitializationSettings,
        iOS: iosInitializationSettings);
     _flutterNotificationPlugin.initialize(initializationSettings,//aur say local notification initialized
        onDidReceiveNotificationResponse: (payload){
       handleMessage(context,message);
        });




  }
//yeh toh local notification ke liye banaya gaya hai devie specific aur yaha bi ioskek liye
//flutter khud handle krta hai bs andorid ke liye thi main yeh khani using flitter_localnotifications
  void fireBaseInit(BuildContext context)async {
    FirebaseMessaging.onMessage.listen((message) {

       if (kDebugMode) {
         print(message.notification!.title.toString());
         print(message.notification!.body.toString());
         print(message.data['viki'].toString());

       }
       initLocalNotifications(context,message);
      showNotifications(message);

    });
  }

Future<void>showNotifications(RemoteMessage message)async {
  AndroidNotificationChannel channel=AndroidNotificationChannel(Random.secure().nextInt(10000).toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      'High Imp Notification');//ab yeh aai hui notification ko channel aur flutter ke localnotifiaction ke pakage ko ko jodega
  //jo ki ham ek chaanl phle hi androidmanifest mein add kr diye hai sath hi flutternotification ko phle hi initialise kr diye ab show
  AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(channel.id.toString(),
      channel.name.toString(),
  priority: Priority.high,
  playSound: true,
  importance: Importance.high,
  ticker: 'ticker',);//Puri notification ki  detailing Yehi se Hogi
DarwinNotificationDetails  darwinNotificationDetails=const DarwinNotificationDetails(presentAlert: true,
presentBadge: true,
presentSound: true);
NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails,
iOS: darwinNotificationDetails);
Future.delayed(Duration.zero,(){
  _flutterNotificationPlugin.show(0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
    notificationDetails
      );
});
}
void handleMessage(BuildContext context,RemoteMessage message){
    if(message.data['viki'].toString()=='viki'){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>const EventScreen(title: '123456',)));
    }

}
  Future<void> setupInteractMessage(BuildContext context)async{
//payload mein to vo  aa gaya jab app on ho kuch navigate ya action lena ho
    // when app is terminated
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }

}