import 'package:flutter/cupertino.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key, required this.title});
final String title;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title),);
  }
}
