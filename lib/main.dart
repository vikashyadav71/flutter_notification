import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'Screen1.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')//isolates
Future<void>_backgroundNotificationHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
}
void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessaging.onBackgroundMessage(_backgroundNotificationHandler);
  runApp(const MyApp());}


 class MyApp extends StatelessWidget {
   const MyApp({super.key});

   @override
   Widget build(BuildContext context) {
     return const MaterialApp(home: Screen1());
   }
 }

