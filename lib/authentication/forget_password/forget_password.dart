import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/authentication/forget_password/forget_password_bloc.dart';
import 'package:lets_chat/utils/image_strings.dart';
import 'package:lets_chat/utils/size.dart';
import 'package:lets_chat/utils/text_strings.dart';
import 'package:lets_chat/utils/validation.dart';

import '../../utils/colors.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late ForgetPasswordBloc forgetPasswordBloc;
  Validation validation = Validation();

  @override
  void didChangeDependencies() {
    forgetPasswordBloc = ForgetPasswordBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    forgetPasswordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(right: deviceWidth * 0.030, left: deviceWidth * 0.030),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: deviceHeight * 0.15,
              ),
              Center(
                child: SvgPicture.asset(
                  LImages.forgetPassword,
                  width: deviceWidth * 0.45,
                  height: deviceHeight * 0.225,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.030,
              ),
              Text(
                LTexts.forget,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: deviceDiagonal * 0.060),
              ),
              Text(
                LTexts.password1,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: deviceDiagonal * 0.060),
              ),
              SizedBox(
                height: deviceHeight * 0.020,
              ),
              Text(
                LTexts.forgetPasswordMessage,
                style: TextStyle(color: Colors.black, fontSize: deviceDiagonal * 0.025),
              ),
              SizedBox(
                height: deviceHeight * 0.020,
              ),
              Form(key: forgetPasswordBloc.forgetPasswordFormKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: forgetPasswordBloc.emailController,
                  cursorColor: LColors.primary,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Iconsax.direct_right,
                        color: LColors.primary,
                      ),
                      hintStyle: TextStyle(color: Colors.black38, fontWeight: FontWeight.w300),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(10))),
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
              ),
              SizedBox(
                height: deviceHeight * 0.020,
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
                      forgetPasswordBloc.forgetPassword();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: StreamBuilder<bool>(
                      stream: forgetPasswordBloc.isLoadingStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return SizedBox(
                              width: deviceWidth * 0.050,
                              height: deviceHeight * 0.025,
                              child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                        } else {
                          return const Text(
                            LTexts.resetPassword,
                            style: TextStyle(color: Colors.white),
                          );
                        }
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
