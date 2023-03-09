import 'package:flutter/cupertino.dart';
import 'package:todoapp/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  build(context) {
    return const CupertinoApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
