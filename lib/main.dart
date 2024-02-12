import 'package:flutter/material.dart';
import 'package:workely_app/my%20home%20pages/homepages.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter('hive_boxes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WORKELY_APP',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Homepages(),
    );
  }
}
