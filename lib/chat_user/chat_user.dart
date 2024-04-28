import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lets_chat/chat_user/chat_user_bloc.dart';
import 'package:lets_chat/utils/image_strings.dart';
import 'package:lets_chat/utils/size.dart';
import 'package:shimmer/shimmer.dart';

import '../chat_room/chat_room.dart';
import '../utils/colors.dart';
import '../utils/text_strings.dart';

class ChatUser extends StatefulWidget {
  const ChatUser({super.key});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  late ChatUserBloc chatUserBloc;

  @override
  void didChangeDependencies() {
    chatUserBloc = ChatUserBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    chatUserBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          LTexts.chatUser,
          style: TextStyle(color: Colors.black),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
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
        margin: EdgeInsets.all(deviceDiagonal * 0.010),
        child: StreamBuilder(
          stream: chatUserBloc.databaseReference.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  margin: EdgeInsets.only(
                      left: deviceWidth * 0.025,
                      right: deviceWidth * 0.025,
                      top: deviceHeight * 0.010,
                      bottom: deviceHeight * 0.010),
                  child: ListView.separated(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(deviceDiagonal * 0.045), // Image radius
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.020,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(deviceDiagonal * 0.010))),
                                width: deviceWidth * 0.40,
                                height: deviceHeight * 0.015,
                              ),
                              SizedBox(
                                height: deviceHeight * 0.010,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(deviceDiagonal * 0.010))),
                                width: deviceWidth * 0.60,
                                height: deviceHeight * 0.015,
                              )
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.white,
                        thickness: 2,
                        indent: deviceWidth * 0.020,
                        endIndent: deviceWidth * 0.020,
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.data?.snapshot.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      LImages.empty,
                      width: deviceWidth * 0.1,
                      height: deviceHeight * 0.2,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.030,
                    ),
                    Text(
                      LTexts.noHistory,
                      style: TextStyle(
                          color: LColors.primary, fontWeight: FontWeight.bold, fontSize: deviceDiagonal * 0.030),
                    )
                  ],
                ),
              );
            }else {
              Map<dynamic, dynamic> chatData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<Map<dynamic, dynamic>> chatUsers = [];
              chatData.forEach((key, value) {
                Map<dynamic, dynamic> chatUser = value;
                chatUser['key'] = key;
                chatUsers.add(chatUser);
              });
              chatUsers.removeWhere((user) => user["uid"] == FirebaseAuth.instance.currentUser!.uid);
              return ListView.separated(
                padding: EdgeInsets.only(bottom: deviceHeight * 0.040),
                itemCount: chatUsers.length,
                itemBuilder: (context, index) {
                  var chatUser = chatUsers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                            userData: chatUser,
                            /* fullName: chatUser.fullName,
                            email: chatUser.email,
                            image: chatUser.image,
                            aboutMe: chatUser.aboutMe,
                            mobileNumber: chatUser.mobileNumber,
                            pushToken: chatUser.pushToken,
                            uid: chatUser.uid,*/
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(
                          left: deviceWidth * 0.025,
                          right: deviceWidth * 0.025,
                          top: deviceHeight * 0.010,
                          bottom: deviceHeight * 0.010),
                      child: Row(
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(deviceDiagonal * 0.045), // Image radius
                              child: Image.network(chatUser["image"], fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.020,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    chatUser["full_name"],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(chatUser["about_me"]),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: LColors.primary.withOpacity(0.4),
                    thickness: 2,
                    indent: deviceWidth * 0.020,
                    endIndent: deviceWidth * 0.020,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
