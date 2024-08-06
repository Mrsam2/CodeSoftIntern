import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/pages/homeView2.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}
