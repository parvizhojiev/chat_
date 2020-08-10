import 'package:chat_app/auth/signUp.dart';
import 'package:chat_app/styles/textFieldStyles.dart';
import 'package:chat_app/styles/textStyles.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  signMeIn(){
    if(formKey.currentState.validate()) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(28),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      width: 270,
                      child: TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                            ? null : 'Invalid email';
                        },
                        decoration: form('Email'),
                      )
                    ),
                    Container(
                      width: 270,
                      child: TextFormField(
                        validator: (val){
                          return val.length < 6 || val.isEmpty ? 'Password must contain 6+ symbols' : null;
                        },
                        decoration: form('Password'),
                      )
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                child: Text('Forgot password', style: linkText()),
              ),
              Container(
                width: 270,
                height: 45,
                margin: EdgeInsets.only(top: 8, bottom: 8),
                child: RaisedButton(
                  child: Text('Sign in'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: (){},
                ),
              ),
              Container(
                width: 270,
                height: 45,
                margin: EdgeInsets.only(top: 8),
                child: RaisedButton(
                  child: Text('Sign in with Google'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Colors.amber,
                  textColor: Colors.white,
                  onPressed: (){},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? ', style: simpleText(),),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Register now', style: linkText(),)
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SignUp()
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