import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/bloc/bloc.dart';

class ChatUserBloc implements Bloc {
  BuildContext context;

  ChatUserBloc(this.context);

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('Users');

  @override
  void dispose() {}
}
