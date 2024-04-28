import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/authentication/google/google_signIn_bloc.dart';
import 'package:lets_chat/authentication/registration/registration_bloc.dart';
import 'package:lets_chat/utils/colors.dart';
import 'package:lets_chat/utils/image_strings.dart';
import 'package:lets_chat/utils/size.dart';
import 'package:lets_chat/utils/text_strings.dart';
import 'package:lets_chat/utils/validation.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationBloc registrationBloc;
  late GoogleSignInBloc googleSignInBloc;
  late Validation validation = Validation();

  @override
  void didChangeDependencies() {
    registrationBloc = RegistrationBloc(context);
    googleSignInBloc = GoogleSignInBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    registrationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
            style: IconButton.styleFrom(foregroundColor: LColors.primary),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: Container(
        margin: EdgeInsets.all(deviceDiagonal * 0.030),
        child: SingleChildScrollView(
          child: Form(
            key: registrationBloc.registrationFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  LTexts.signUpTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  height: deviceHeight * 0.010,
                ),
                Text(
                  LTexts.subSignUpTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
                                        registrationBloc.imgFromGallery();
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
                                        registrationBloc.imgFromCamera();
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
                    child: StreamBuilder<File?>(
                      stream: registrationBloc.galleryFileStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(60), // Image radius
                              child: Image.file(snapshot.data!, fit: BoxFit.cover),
                            ),
                          );
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
                  controller: registrationBloc.firstNameRegistrationController,
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
                  controller: registrationBloc.lastNameRegistrationController,
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
                  controller: registrationBloc.emailRegistrationController,
                  cursorColor: LColors.primary,
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
                          borderSide: BorderSide(color: LColors.primary),
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
                  controller: registrationBloc.phoneNumberRegistrationController,
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
                StreamBuilder(
                  stream: registrationBloc.showPasswordStream,
                  builder: (context, snapshot) {
                    bool showPassword = snapshot.data ?? false;
                    return TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: registrationBloc.passwordRegistrationController,
                      obscureText: !showPassword,
                      cursorColor: LColors.primary,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Iconsax.password_check,
                            color: LColors.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword ? Iconsax.eye : Iconsax.eye_slash,
                              color: LColors.primary,
                            ),
                            onPressed: () {
                              registrationBloc.showPasswordStreamController.add(!showPassword);
                            },
                          ),
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: LColors.primary),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelText: (LTexts.password),
                          labelStyle: const TextStyle(color: LColors.primary),
                          errorStyle: const TextStyle(color: Colors.redAccent)),
                      validator: (password) {
                        return validation.passwordValidation(password);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                StreamBuilder(
                  stream: registrationBloc.showConfirmPasswordStream,
                  builder: (context, snapshot) {
                    bool showPassword = snapshot.data ?? false;
                    return TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: registrationBloc.confirmPasswordRegistrationController,
                      obscureText: !showPassword,
                      cursorColor: LColors.primary,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Iconsax.password_check,
                            color: LColors.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword ? Iconsax.eye : Iconsax.eye_slash,
                              color: LColors.primary,
                            ),
                            onPressed: () {
                              registrationBloc.showConfirmPasswordStreamController.add(!showPassword);
                            },
                          ),
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: LColors.primary),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          labelText: (LTexts.confirmPassword),
                          labelStyle: const TextStyle(color: LColors.primary),
                          errorStyle: const TextStyle(color: Colors.redAccent)),
                      validator: (confirmPassword) {
                        return validation.confirmPasswordValidation(
                            confirmPassword, registrationBloc.passwordRegistrationController.text);
                      },
                    );
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(deviceDiagonal * 0.025),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                          backgroundColor: LColors.primary,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        registrationBloc.registration();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: StreamBuilder<bool>(
                        stream: registrationBloc.isLoadingStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return SizedBox(
                                width: deviceWidth * 0.050,
                                height: deviceHeight * 0.025,
                                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                          } else {
                            return const Text(
                              LTexts.createAccount,
                              style: TextStyle(color: Colors.white),
                            );
                          }
                        },
                      )),
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black54,
                        indent: 60,
                        endIndent: 5,
                      ),
                    ),
                    Text(
                      LTexts.orSignUpWith,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Flexible(
                      child: Divider(
                        color: Colors.black54,
                        thickness: 0.5,
                        indent: 5,
                        endIndent: 60,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        onPressed: () {
                          googleSignInBloc.signInWithGoogle();
                        },
                        icon: SvgPicture.asset(
                          LImages.googleIcon,
                          width: deviceWidth * 0.090,
                          height: deviceHeight * 0.040,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
