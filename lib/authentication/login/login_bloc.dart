import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:lets_chat/bloc/bloc.dart';
import 'package:lets_chat/chat_history/chat_history.dart';

class LoginBloc implements Bloc {
  BuildContext context;

  LoginBloc(this.context);

  late StreamController<bool> showPasswordStreamController = StreamController<bool>();

  Stream<bool> get showPasswordStream => showPasswordStreamController.stream;
  late StreamController<bool> isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => isLoadingController.stream;

  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  UserCredential? credential;
  String? token;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  User? get user => firebaseAuth.currentUser;

  login() async {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      try {
        isLoadingController.add(true);
        credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailLoginController.text.toString(), password: passwordLoginController.text.toString());
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatHistory(),
              ));
        }
        isLoadingController.add(false);
      } catch (e) {
        isLoadingController.add(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Login Failed",
              style: TextStyle(fontSize: 16),
            ),
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    showPasswordStreamController.close();
    emailLoginController.dispose();
    passwordLoginController.dispose();
  }
}
