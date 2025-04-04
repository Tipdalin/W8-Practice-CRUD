import 'package:flutter/material.dart';

class DebugCreator {
  static bool debugMode = false;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Debug Creator Example'),
        ),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Flutter Demo',
    );
  }
}
