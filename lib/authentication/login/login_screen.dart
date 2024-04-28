import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/authentication/google/google_signIn_bloc.dart';
import 'package:lets_chat/authentication/login/login_bloc.dart';
import 'package:lets_chat/authentication/registration/registration_screen.dart';
import 'package:lets_chat/utils/colors.dart';
import 'package:lets_chat/utils/image_strings.dart';
import 'package:lets_chat/utils/size.dart';
import 'package:lets_chat/utils/text_strings.dart';
import 'package:lets_chat/utils/validation.dart';

import '../forget_password/forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc loginBloc;
  late GoogleSignInBloc googleSignInBloc;
  final Validation validation = Validation();

  @override
  void didChangeDependencies() {
    loginBloc = LoginBloc(context);
    googleSignInBloc = GoogleSignInBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(deviceDiagonal * 0.030),
          child: Center(
            child: Form(
              key: loginBloc.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.05,
                  ),
                  SvgPicture.asset(LImages.loginIcon, width: deviceWidth * 0.20, height: deviceHeight * 0.20),
                  SizedBox(
                    height: deviceHeight * 0.015,
                  ),
                  Text(LTexts.loginTitle, style: Theme.of(context).textTheme.headlineLarge),
                  SizedBox(
                    height: deviceHeight * 0.010,
                  ),
                  Text(
                    LTexts.subLoginTitle,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: deviceHeight * 0.020,
                  ),
                  TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: loginBloc.emailLoginController,
                    cursorColor: LColors.primary,
                    keyboardType: TextInputType.emailAddress,
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
                  StreamBuilder(
                    stream: loginBloc.showPasswordStream,
                    builder: (context, snapshot) {
                      bool showPassword = snapshot.data ?? false;
                      return TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: loginBloc.passwordLoginController,
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
                                loginBloc.showPasswordStreamController.add(!showPassword);
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
                    height: deviceHeight * 0.010,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        style: TextButton.styleFrom(foregroundColor: LColors.primary),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPassword(),));
                        },
                        child: const Text(
                          LTexts.forgetPassword,
                          style: TextStyle(color: LColors.primary),
                        )),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.010,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: LColors.primary,
                            padding: EdgeInsets.all(deviceDiagonal * 0.025),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                            foregroundColor: Colors.white),
                        onPressed: () {
                          loginBloc.login();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: StreamBuilder<bool>(
                          stream: loginBloc.isLoadingStream,
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              return SizedBox(
                                  width: deviceWidth * 0.050,
                                  height: deviceHeight * 0.025,
                                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                            } else {
                              return const Text(
                                LTexts.signIn,
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          },
                        )),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.010,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(deviceDiagonal * 0.025),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                            foregroundColor: LColors.primary),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegistrationScreen(),
                              ));
                        },
                        child: const Text(
                          LTexts.createAccount,
                          style: TextStyle(color: Colors.black),
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
                        LTexts.orSignInWith,
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
      ),
    );
  }
}
