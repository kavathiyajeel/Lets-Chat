import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/authentication/login/login_bloc.dart';
import 'package:lets_chat/authentication/login/login_screen.dart';
import 'package:lets_chat/chat_history/chat_history.dart';

import 'package:lets_chat/utils/colors.dart';
import 'package:lets_chat/utils/size.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StreamBuilder(
                stream: LoginBloc(context).authStateChanges,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const ChatHistory();
                  } else {
                    return const LoginScreen();
                  }
                },
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: LColors.primary,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.dark),
      ),
      body: Container(
        color: LColors.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                  child: Lottie.asset(
                "assets/lottie/lottie_chat.json",
              )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: deviceHeight * 0.090),
                child: Text(
                  "Let's Chat",
                  style: TextStyle(color: Colors.white, fontSize: deviceDiagonal * 0.050),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
