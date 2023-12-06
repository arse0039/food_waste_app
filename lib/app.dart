import 'package:flutter/material.dart';
import 'components/list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Color.fromRGBO(105, 181, 102, 1.0)),
        home: Center(child: ListScreen()));
  }
}
