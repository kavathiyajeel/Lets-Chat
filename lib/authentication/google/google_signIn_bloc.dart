import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lets_chat/bloc/bloc.dart';
import 'package:lets_chat/chat_history/chat_history.dart';



class GoogleSignInBloc implements Bloc {
  BuildContext context;

  GoogleSignInBloc(this.context);

  UserCredential? credential;
  String? token;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn(scopes: <String>["email"]).signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final googleCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
      credential = await FirebaseAuth.instance.signInWithCredential(googleCredential);
      token = await FirebaseMessaging.instance.getToken();

      String uid = credential!.user!.uid;

      Map<String, dynamic> data = {
        'uid': uid,
        'full_name': firebaseAuth.currentUser?.displayName,
        'email': firebaseAuth.currentUser!.email,
        'mobile_number': firebaseAuth.currentUser!.phoneNumber ?? "",
        'pushToken': token,
        'image': firebaseAuth.currentUser!.photoURL,
        'about_me': "Hey there! I am using Let's Chat"
      };

      await FirebaseDatabase.instance.ref().child("Users").child(uid).set(data);
      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatHistory(),
            ));
      }
    } catch (e) {
      debugPrint("Error is == $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Google SignIn Failed",
            style: TextStyle(fontSize: 16),
          ),
        ));
      }
    }
  }

  @override
  void dispose() {}
}
