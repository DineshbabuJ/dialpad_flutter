import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_appp/screens/home_screen.dart';
import 'package:practice_appp/screens/login_screen.dart';

class AuthProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passLoginController = TextEditingController();
  User? user;

  bool loggingIn = false;
  bool registeringUser = false;
  bool loggingOut = false;

  register(BuildContext context) async {
    registeringUser = true;
    notifyListeners();

    print('registration started');
    try {
      final credential =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      ));

      if (credential.user != null) {
        user = credential.user;
        print(credential.user!.uid);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'name': nameController.text,
          'email': emailController.text,
          'uid': credential.user!.uid
        });

        nameController.clear();
        emailController.clear();
        passController.clear();

        registeringUser = false;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    registeringUser = false;
    notifyListeners();
  }

  login(BuildContext context) async {
    loggingIn = true;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailLoginController.text,
        password: passLoginController.text,
      );

      if (credential.user != null) {
        user = credential.user;

        print(credential.user!.uid);

        emailLoginController.clear();
        passLoginController.clear();

        loggingIn = false;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        print(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e);
      }
    } catch (e) {
      print(e);
    }
    loggingIn = false;
    notifyListeners();
  }

  logout(context) async {
    loggingOut = true;
    notifyListeners();

    FirebaseAuth.instance.signOut();
    loggingOut = false;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void loadUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      user = FirebaseAuth.instance.currentUser;
      // notifyListeners();
    }
  }
}
