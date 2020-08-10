import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static Future signIn(String email, String password) async{
    AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    return user;
  }

  static Future signUp(String email, String password) async{
    AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    return user;
  }
}