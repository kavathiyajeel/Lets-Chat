import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


import 'package:lets_chat/bloc/bloc.dart';
import 'package:lets_chat/chat_history/chat_history.dart';
import 'package:lets_chat/utils/colors.dart';
import 'package:lets_chat/utils/size.dart';



class RegistrationBloc implements Bloc {
  BuildContext context;

  RegistrationBloc(this.context);

  File? galleryFile;
  final picker = ImagePicker();
  UserCredential? credential;
  String? token;

  late StreamController<File?> galleryFileStreamController = StreamController<File?>.broadcast();

  Stream<File?> get galleryFileStream => galleryFileStreamController.stream;

  late StreamController<bool> showPasswordStreamController = StreamController<bool>.broadcast();

  Stream<bool> get showPasswordStream => showPasswordStreamController.stream;

  late StreamController<bool> showConfirmPasswordStreamController = StreamController<bool>.broadcast();

  Stream<bool> get showConfirmPasswordStream => showConfirmPasswordStreamController.stream;

  late StreamController<bool> isLoadingController = StreamController<bool>.broadcast();

  Stream<bool> get isLoadingStream => isLoadingController.stream;

  final TextEditingController emailRegistrationController = TextEditingController();
  final TextEditingController passwordRegistrationController = TextEditingController();
  final TextEditingController firstNameRegistrationController = TextEditingController();
  final TextEditingController lastNameRegistrationController = TextEditingController();
  final TextEditingController phoneNumberRegistrationController = TextEditingController();
  final TextEditingController confirmPasswordRegistrationController = TextEditingController();
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();

  registration() async {
    final isValid = registrationFormKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      try {
        isLoadingController.add(true);
        token = await FirebaseMessaging.instance.getToken();
        debugPrint("Token is = $token");
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailRegistrationController.text.toString(),
            password: passwordRegistrationController.text.toString());

        String uid = credential!.user!.uid;
        Reference storageReference = FirebaseStorage.instance.ref().child('Users images / ${DateTime.now()}.png');
        UploadTask uploadTask = storageReference.putFile(galleryFile!);
        TaskSnapshot storageTaskSnapshot = await uploadTask;
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

        Map<String, dynamic> data = {
          'uid': uid,
          'full_name' : "${firstNameRegistrationController.text.toString().trim()} ${lastNameRegistrationController.text.toString().trim()}",
          'email': emailRegistrationController.text.toString().trim(),
          'mobile_number': phoneNumberRegistrationController.text.toString().trim(),
          'pushToken': token,
          'image': downloadUrl,
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

        isLoadingController.add(false);
      } catch (e) {
        isLoadingController.add(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Registration Failed",
            style: TextStyle(fontSize: deviceDiagonal * 0.025),
          )));
        }
      }
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
      galleryFileStreamController.add(File(croppedFile.path));
    }
  }

  @override
  void dispose() {
    showPasswordStreamController.close();
    emailRegistrationController.dispose();
    passwordRegistrationController.dispose();
    confirmPasswordRegistrationController.dispose();
    firstNameRegistrationController.dispose();
    lastNameRegistrationController.dispose();
    phoneNumberRegistrationController.dispose();
    isLoadingController.close();
  }
}
