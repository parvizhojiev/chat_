import 'package:chat_app/auth/signIn.dart';
import 'package:chat_app/styles/textFieldStyles.dart';
import 'package:chat_app/styles/textStyles.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(28),
          child: Column(
            children: [
              Container(
                width: 270,
                child: TextField(decoration: form('User name'),)
              ),
              Container(
                width: 270,
                child: TextField(decoration: form('Email'),)
              ),
              Container(
                width: 270,
                child: TextField(decoration: form('Password'),)
              ),
              Container(
                width: 270,
                height: 45,
                margin: EdgeInsets.only(top: 24, ),
                child: RaisedButton(
                  child: Text('Sign up'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: (){},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: simpleText(),),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Sign in now', style: linkText(),)
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SignIn()
                        )
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}