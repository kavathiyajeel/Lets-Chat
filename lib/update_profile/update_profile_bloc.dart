import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/authentication/login/login_screen.dart';

import '../bloc/bloc.dart';
import '../utils/colors.dart';
import '../utils/size.dart';

class UpdateProfileBloc implements Bloc {
  BuildContext context;

  UpdateProfileBloc(this.context) {
    getUserData();
  }

  File? galleryFile;
  final picker = ImagePicker();

  /*UserCredential? credential;
  String? token;*/

  late StreamController<dynamic> galleryFileStreamController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get galleryFileStream => galleryFileStreamController.stream;

  late StreamController<bool> isUpdateController = StreamController<bool>.broadcast();

  Stream<bool> get isUpdateStream => isUpdateController.stream;

  late StreamController<bool> isDeleteController = StreamController<bool>.broadcast();

  Stream<bool> get isDeleteStream => isDeleteController.stream;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final GlobalKey<FormState> updateProfileFormKey = GlobalKey<FormState>();

  var user = FirebaseAuth.instance.currentUser!.uid;
  var userRemove = FirebaseAuth.instance.currentUser;
  late DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("Users").child(user);

  getUserData() async {
    DataSnapshot dataSnapshot = await databaseReference.get();
    Map user = dataSnapshot.value as Map;
    String fullName = user["full_name"];
    var names = fullName.split(' ');
    emailController.text = user["email"];
    firstNameController.text = names[0];
    lastNameController.text = names[1];
    phoneNumberController.text = user["mobile_number"];
    aboutMeController.text = user["about_me"];
    galleryFileStreamController.add(user['image']);
  }

  updateUserData() async {
    final isValid = updateProfileFormKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      try {
        isUpdateController.add(true);
        if (galleryFile != null) {
          Reference reference = FirebaseStorage.instance.ref().child('Users images / ${DateTime.now()}.png');
          UploadTask uploadTask = reference.putFile(galleryFile!);
          TaskSnapshot storageTaskSnapshot = await uploadTask;
          String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
          Map<String, String> data = {
            'full_name': "${firstNameController.text.toString().trim()} ${lastNameController.text.toString().trim()}",
            'mobile_number': phoneNumberController.text.toString(),
            'about_me' :aboutMeController.text.toString(),
            'image': downloadUrl,
          };
          databaseReference.update(data);
        } else {
          Map<String, String> data = {
            'full_name': "${firstNameController.text.toString().trim()} ${lastNameController.text.toString().trim()}",
            'mobile_number': phoneNumberController.text.toString(),
            'about_me' :aboutMeController.text.toString(),
          };
          databaseReference.update(data);
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Update Profile Successfully",
            style: TextStyle(fontSize: deviceDiagonal * 0.025),
          )));
        }
        isUpdateController.add(false);
      } catch (e) {
        isUpdateController.add(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Update Profile Failed",
            style: TextStyle(fontSize: deviceDiagonal * 0.025),
          )));
        }
      }
    }
  }

  deleteUserData() {
    try{
      isDeleteController.add(true);
      databaseReference.remove();
      userRemove!.delete();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Delete Account Successfully",
              style: TextStyle(fontSize: deviceDiagonal * 0.025),
            )));
      }
      isDeleteController.add(false);
    }catch(e){
      isDeleteController.add(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Delete Account Failed",
              style: TextStyle(fontSize: deviceDiagonal * 0.025),
            )));
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
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    isDeleteController.close();
    isUpdateController.close();
  }
}
