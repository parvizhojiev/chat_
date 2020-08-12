import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRooms.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController =
      new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signUp() async {

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text,
        passwordEditingController.text).then((result){
          if(result != null){

          Map<String,String> userDataMap = {
            "userName" : usernameEditingController.text,
            "userEmail" : emailEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: actionBar(context, 'Регистрация'),
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
                        controller: usernameEditingController,
                        validator: (val) {
                          return val.length >= 4 ? null : "Имя должно иметь 4+ символов";
                        },
                        decoration: form('Имя'),
                      ),
                    ),
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
              Container(
                width: 275,
                height: 45,
                margin: EdgeInsets.only(top: 8, bottom: 12),
                child: RaisedButton(
                  child: Text('Регистрация', style: simpleText()),
                  color: Colors.amber,
                  textColor: Colors.white,
                  onPressed: (){
                    signUp();
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
                    "Уже есть аккаунт? ",
                    style: smallText(),
                  ),
                  GestureDetector(
                    child: Text(
                      "Войдите сейчас",
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
