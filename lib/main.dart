import 'package:chat_app/auth/signIn.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: InkRipple.splashFactory,
        primaryColor: Colors.teal,
      ),
      home: SignIn(),
    );
  }
}