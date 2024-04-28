import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/authentication/login/login_screen.dart';
import 'package:lets_chat/bloc/bloc.dart';

class ForgetPasswordBloc implements Bloc {
  BuildContext context;

  ForgetPasswordBloc(this.context);

  late StreamController<bool> isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => isLoadingController.stream;
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();


  forgetPassword() async {
    final isValid = forgetPasswordFormKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      try{
        isLoadingController.add(true);
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toString());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Password Reset Email Sent",
              style: TextStyle(fontSize: 16),
            ),
          ));
        }
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
        isLoadingController.add(false);
      }catch(e){
        isLoadingController.add(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Forget Password Failed",
              style: TextStyle(fontSize: 16),
            ),
          ));
        }
      }


    }
  }

  @override
  void dispose() {
    emailController.dispose();
  }
}
