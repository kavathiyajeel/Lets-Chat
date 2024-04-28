
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_chat/bloc/bloc.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../utils/access_firebase_token.dart';
import '../utils/colors.dart';

class ChatRoomBloc implements Bloc {
  BuildContext context;

  final Map userData;

  ChatRoomBloc(
    this.context,
    this.userData,
  ) {
    senderUid = FirebaseAuth.instance.currentUser!.uid;
    reciverUid = userData['uid'] ?? userData['senderId'] /*uid*/;
    senderEmail = userData['email'] ?? userData['sender_email'] /*email*/;
    senderName = userData['full_name'] ?? userData['sender_name'] /*fullName*/;
    senderRoom = "${senderUid}_$reciverUid";
    reciverRoom = "${reciverUid}_$senderUid";
    dateTime = DateFormat('d MMM yyyy, h:mm a').format(DateTime.now());
    addUserStatus(status: true);
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true));
  }

  late final String senderUid;
  late final String reciverUid;
  late final String senderRoom;
  late final String reciverRoom;
  late final String dateTime;
  late final String senderEmail;
  late final String senderName;
  late final String? profilePic;
  late String token;
  final dio = Dio();
  late bool isButtonEnabled = false;
  File? galleryFile;
  final picker = ImagePicker();

  late String mobileNumber;

  final TextEditingController messageController = TextEditingController();

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  late DatabaseReference databaseReference1 = databaseReference.child('chats').child(senderRoom);

  final usersStream =
      FirebaseDatabase.instance.ref().child('Users').child(FirebaseAuth.instance.currentUser!.uid).get();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference userDatabaseReference = databaseReference.child('Users').child(reciverUid);

  addUserStatus({required bool status}) async {
    final DataSnapshot dataSnapshot = await databaseReference.child("ChatStatus").child(senderRoom).get();
    if (dataSnapshot.exists) {
      databaseReference
          .child("ChatStatus")
          .child(senderRoom)
          .update({'senderId_receiverId': senderRoom, 'status': status});
    } else {
      databaseReference
          .child("ChatStatus")
          .child(senderRoom)
          .set({'senderId_receiverId': senderRoom, 'status': status});
    }
  }

  sendMessage() {
    databaseReference.child('chats').child(senderRoom).push().set({
      'message': messageController.text.isEmpty ? "Hello! 👋" : messageController.text.toString(),
      'senderId': FirebaseAuth.instance.currentUser?.uid,
      'senderEmail': FirebaseAuth.instance.currentUser?.email,
      "type": "text",
      'time': dateTime
    });
    databaseReference.child('chats').child(reciverRoom).push().set({
      'message': messageController.text.isEmpty ? "Hello! 👋" : messageController.text.toString(),
      'senderId': FirebaseAuth.instance.currentUser?.uid,
      'senderEmail': FirebaseAuth.instance.currentUser?.email,
      "type": "text",
      'time': dateTime
    });
  }

  sendImage() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('Chat images').child('$senderUid /  ${DateTime.now()}.png');
    UploadTask uploadTask = storageReference.putFile(galleryFile!);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    databaseReference.child('chats').child(senderRoom).push().set({
      'message': downloadUrl,
      'senderId': FirebaseAuth.instance.currentUser?.uid,
      'senderEmail': FirebaseAuth.instance.currentUser?.email,
      "type": "img",
      'time': dateTime
    });
    databaseReference.child('chats').child(reciverRoom).push().set({
      'message': downloadUrl,
      'senderId': FirebaseAuth.instance.currentUser?.uid,
      'senderEmail': FirebaseAuth.instance.currentUser?.email,
      "type": "img",
      'time': dateTime
    });
  }

  void chatHistory(String message) async {
    String messageKey = reciverUid;
    String messageKey1 = senderUid;
    DatabaseReference ref = databaseReference.child("chatHistory").child(senderUid);

    DatabaseReference ref1 = databaseReference.child("chatHistory").child(messageKey);

    DatabaseReference ref2 = databaseReference.child('Users');
    ref2.child(senderUid).onValue.listen((event) async {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
      Map<String, dynamic> data = {
        'senderId': reciverUid,
        'sender_email': senderEmail,
        'sender_name': senderName,
        'last_message': message,
        'image': userData["image"],
        'time': dateTime
      };
      Map<String, dynamic> data1 = {
        'senderId': senderUid,
        'sender_email': FirebaseAuth.instance.currentUser!.email,
        'sender_name': values['full_name'],
        'last_message': message,
        'image': values['image'],
        'time': dateTime
      };

      if (reciverUid == "") {
        ref.push().set(data);
        ref1.set(data1);
      } else {
        ref.child(messageKey).update(data);
        ref1.child(messageKey1).update(data1);
      }
    });
  }

  sendNotifications(String message) async {
    final DataSnapshot dataSnapshot = await databaseReference.child("ChatStatus").child(reciverRoom).get();
    late bool statusUser;
    if (dataSnapshot.exists) {
      Map<dynamic, dynamic> status = dataSnapshot.value as Map<dynamic, dynamic>;
      statusUser = status["status"];
    }else{
      statusUser = false;
    }

    if (statusUser == false) {
      AccessTokenFirebase accessTokenFirebase = AccessTokenFirebase();
      token = await accessTokenFirebase.getAccessToken();
      debugPrint("Access Token ==== $token");
      DatabaseReference ref2 = databaseReference.child('Users');
      ref2.child(senderUid).onValue.listen((event) {
        DataSnapshot dataSnapshot = event.snapshot;
        Map<dynamic, dynamic> value = dataSnapshot.value as Map<dynamic, dynamic>;
        ref2.child(reciverUid).onValue.listen((event) async {
          DataSnapshot dataSnapshot = event.snapshot;
          Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

          String body = message;
          debugPrint('body=$body');
          Map<String, dynamic> data = {
            'message': {
              'token': values['pushToken'],
              'notification': {'title': value['full_name'], 'body': body},
              "data": {"senderUid": senderUid},
              "android": {
                'notification': {
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                }
              },
            },
          };

          debugPrint("Data=$data");
          messageController.clear();
          await dio.post('https://fcm.googleapis.com/v1/projects/let-s-chat-dd0da/messages:send',
              data: jsonEncode(data),
              options: Options(headers: {
                Headers.contentTypeHeader: 'application/json; UTF-8',
                HttpHeaders.authorizationHeader: 'Bearer $token'
              }));
        });
      });
    } else {
      debugPrint("User Status is online");
      messageController.clear();
    }
  }

  void imgFromGallery() async {
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 100).then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  void imgFromCamera() async {
    await picker.pickImage(source: ImageSource.camera, imageQuality: 100).then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  void _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Crop",
              toolbarColor: LColors.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              cropFrameColor: Colors.white,
              backgroundColor: Colors.white,
              activeControlsWidgetColor: LColors.primary,
              statusBarColor: LColors.primary,
              cropFrameStrokeWidth: 5,
              lockAspectRatio: false),
          IOSUiSettings(title: "Crop")
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      galleryFile = File(croppedFile.path);
      sendImage();
      chatHistory("📷 Photo");
      sendNotifications("📷 Photo");
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    addUserStatus(status: false);
  }
}
