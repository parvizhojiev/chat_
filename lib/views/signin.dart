import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRooms.dart';
import 'package:chat_app/views/forgot_password.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService.signInWithEmailAndPassword(emailEditingController.text, passwordEditingController.text).then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot = await DatabaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: actionBar(context, 'Вход'),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      width: 260,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailEditingController,
                        validator: (val) {
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val) ? null : "Введите правильный email адресс";
                        },
                        decoration: form('Email'),
                      ),
                    ),
                    Container(
                      width: 260,
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordEditingController,
                        validator: (val) {
                          return val.length >= 6 ? null : "Пароль должен иметь 6+ символов";
                        },
                        decoration: form('Пароль'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Забыли пароль?",
                        style: linkText(),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                    },
                  )
                ],
              ),
              Container(
                width: 275,
                height: 45,
                margin: EdgeInsets.only(top: 8, bottom: 8),
                child: RaisedButton(
                  child: Text('Войти', style: simpleText()),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: (){
                    signIn();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Container(
                width: 275,
                height: 45,
                margin: EdgeInsets.only(top: 8, bottom: 12),
                child: RaisedButton(
                  child: Text('Войти с помощью Google', style: simpleText()),
                  color: Colors.amber,
                  textColor: Colors.white,
                  onPressed: (){
                    signIn();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Нет аккаунта? ",
                    style: smallText(),
                  ),
                  GestureDetector(
                    child: Text(
                      "Зарегистрируйтесь",
                      style: linkText(),
                    ),
                    onTap: () {
                      widget.toggleView();
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
