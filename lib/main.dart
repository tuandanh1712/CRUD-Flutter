import 'package:crud/screens/todo_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
 return MaterialApp(
   debugShowCheckedModeBanner: false,
   theme: ThemeData.dark(),
   home: TodoListPage(),
 );
  }
}

