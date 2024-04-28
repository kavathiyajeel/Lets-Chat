import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/bloc/bloc.dart';

class ChatHistoryBloc implements Bloc {
  BuildContext context;

  ChatHistoryBloc(this.context) {
    updateToken();
  }

  late StreamController<bool> isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => isLoadingController.stream;
  String firebaseUser = FirebaseAuth.instance.currentUser!.uid;
  late DatabaseReference databaseReference1 = FirebaseDatabase.instance.ref().child("chatHistory").child(firebaseUser);

  DatabaseReference databaseChat = FirebaseDatabase.instance.ref().child("chats");

  late DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  removeToken() {
    Map<String, dynamic> data = {
      'pushToken': "",
    };
    databaseReference.child('Users').child(firebaseUser).update(data);
  }

  updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    //print("Token is = ${token}");
    Map<String, dynamic> data = {
      'pushToken': token,
    };
    databaseReference.child('Users').child(firebaseUser).update(data);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
