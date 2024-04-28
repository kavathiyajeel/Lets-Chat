import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/update_profile/update_profile_bloc.dart';
import 'package:lets_chat/utils/colors.dart';
import 'package:lets_chat/utils/size.dart';
import 'package:lets_chat/utils/text_strings.dart';
import 'package:lets_chat/utils/validation.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GoogleSignIn googleUser = GoogleSignIn(scopes: <String>["email"]);
  late UpdateProfileBloc updateProfileBloc;
  Validation validation = Validation();

  @override
  void didChangeDependencies() {
    updateProfileBloc = UpdateProfileBloc(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          LTexts.profile,
          style: TextStyle(color: Colors.black),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_sharp)),
      ),
      body: Container(
        margin: EdgeInsets.all(deviceDiagonal * 0.030),
        child: SingleChildScrollView(
          child: Form(
            key: updateProfileBloc.updateProfileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: deviceHeight * 0.020,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                            minimum: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: LColors.primary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        updateProfileBloc.imgFromGallery();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.photo_album,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Gallery",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: LColors.primary),
                                    onPressed: () {
                                      setState(() {
                                        updateProfileBloc.imgFromCamera();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Camera",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                            ]));
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(deviceDiagonal * 0.005),
                    decoration: const BoxDecoration(color: LColors.primary, shape: BoxShape.circle),
                    child: StreamBuilder<dynamic>(
                      stream: updateProfileBloc.galleryFileStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          if (data is File) {
                            return ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(60), // Image radius
                                child: Image.file(data, fit: BoxFit.cover),
                              ),
                            );
                          } else if (data is String) {
                            return ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(60), // Image radius
                                child: Image.network(data, fit: BoxFit.cover),
                              ),
                            );
                          } else {
                            return ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(60), // Image radius
                                child: Image.file(snapshot.data!, fit: BoxFit.cover),
                              ),
                            );
                          }
                        } else {
                          return ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(deviceDiagonal * 0.1), // Image radius
                              child: Image.asset('assets/photo/man.jpg', fit: BoxFit.cover),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.020,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: updateProfileBloc.firstNameController,
                  cursorColor: LColors.primary,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Iconsax.user,
                        color: LColors.primary,
                      ),
                      hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: LColors.primary),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: (LTexts.firstname),
                      labelStyle: TextStyle(color: LColors.primary),
                      errorStyle: TextStyle(color: Colors.redAccent)),
                  validator: (firstname) {
                    return validation.firstNameValidation(firstname);
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: updateProfileBloc.lastNameController,
                  cursorColor: LColors.primary,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Iconsax.user,
                        color: LColors.primary,
                      ),
                      hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: LColors.primary),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: (LTexts.lastname),
                      labelStyle: TextStyle(color: LColors.primary),
                      errorStyle: TextStyle(color: Colors.redAccent)),
                  validator: (lastname) {
                    return validation.lastNameValidation(lastname);
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: updateProfileBloc.emailController,
                  cursorColor: LColors.primary,
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Iconsax.direct_right,
                        color: LColors.primary,
                      ),
                      hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: (LTexts.email),
                      labelStyle: TextStyle(color: LColors.primary),
                      errorStyle: TextStyle(color: Colors.redAccent)),
                  validator: (email) {
                    return validation.emailValidation(email);
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: updateProfileBloc.phoneNumberController,
                  cursorColor: LColors.primary,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Iconsax.call,
                        color: LColors.primary,
                      ),
                      hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: LColors.primary),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: (LTexts.phoneNo),
                      labelStyle: TextStyle(color: LColors.primary),
                      errorStyle: TextStyle(color: Colors.redAccent)),
                  validator: (phoneNumber) {
                    return validation.mobileNumberValidation(phoneNumber);
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: updateProfileBloc.aboutMeController,
                  cursorColor: LColors.primary,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Iconsax.information,
                        color: LColors.primary,
                      ),
                      hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: LColors.primary),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: (LTexts.aboutMe),
                      labelStyle: TextStyle(color: LColors.primary),
                      errorStyle: TextStyle(color: Colors.redAccent)),
                  validator: (aboutMe) {
                    return validation.aboutMeValidation(aboutMe);
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.030,
                ),
                Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(deviceDiagonal * 0.025),
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                                backgroundColor: LColors.primary,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              updateProfileBloc.updateUserData();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: StreamBuilder<bool>(
                              stream: updateProfileBloc.isUpdateStream,
                              builder: (context, snapshot) {
                                if (snapshot.data == true) {
                                  return SizedBox(
                                      width: deviceWidth * 0.050,
                                      height: deviceHeight * 0.025,
                                      child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                                } else {
                                  return const Text(
                                    LTexts.update,
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                              },
                            )),
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.020,
                    ),
                    Flexible(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(deviceDiagonal * 0.025),
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                                backgroundColor: LColors.primary,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  surfaceTintColor: Colors.white,
                                  title: const Text(
                                    "Delete",
                                    style: TextStyle(color: LColors.primary),
                                  ),
                                  content: const Text("Are you sure you want to delete this Account?"),
                                  actions: [
                                    TextButton(
                                        style: TextButton.styleFrom(foregroundColor: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("CANCEL", style: TextStyle(color: LColors.primary))),
                                    GestureDetector(
                                      onTap: () {
                                        updateProfileBloc.deleteUserData();
                                      },
                                      child: TextButton(
                                          style: TextButton.styleFrom(foregroundColor: Colors.white),
                                          onPressed: null,
                                          child: const Text(
                                            "OK",
                                            style: TextStyle(color: LColors.primary),
                                          )),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: StreamBuilder<bool>(
                              stream: updateProfileBloc.isDeleteStream,
                              builder: (context, snapshot) {
                                if (snapshot.data == true) {
                                  return SizedBox(
                                      width: deviceWidth * 0.050,
                                      height: deviceHeight * 0.025,
                                      child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                                } else {
                                  return const Text(
                                    LTexts.delete,
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
