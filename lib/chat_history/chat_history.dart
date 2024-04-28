import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lets_chat/chat_history/chat_history_bloc.dart';
import 'package:lets_chat/chat_user/chat_user.dart';
import 'package:lets_chat/update_profile/update_profile.dart';
import 'package:lets_chat/utils/colors.dart';
import 'package:lets_chat/utils/image_strings.dart';

import 'package:shimmer/shimmer.dart';

import '../authentication/login/login_screen.dart';
import '../chat_room/chat_room.dart';

import '../notifications/NotificationServices.dart';
import '../utils/size.dart';
import '../utils/text_strings.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory>{
  late ChatHistoryBloc chatHistoryBloc;

  @override
  void didChangeDependencies() {
    chatHistoryBloc = ChatHistoryBloc(context);
    super.didChangeDependencies();
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.setupInteractMessage(context);
    //notificationServices.firebaseInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          LTexts.letsChat,
          style: TextStyle(color: Colors.black),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton(
            iconColor: Colors.black,
            surfaceTintColor: Colors.white,
            offset: const Offset(1, kToolbarHeight),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdateProfile(),
                          ));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.profile_circle,
                          color: LColors.primary,
                        ),
                        SizedBox(width: deviceWidth * 0.020),
                        const Text(LTexts.profile)
                      ],
                    )),
                PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                            insetPadding: EdgeInsets.all(deviceDiagonal * 0.040),
                            surfaceTintColor: Colors.white,
                            child: Container(
                              margin: EdgeInsets.all(deviceDiagonal * 0.020),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: LColors.primary,
                                    size: deviceDiagonal * 0.10,
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.015,
                                  ),
                                  Text(
                                    LTexts.logOut,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: deviceDiagonal * 0.038,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.020,
                                  ),
                                  Text(
                                    LTexts.logOutMessage,
                                    style: TextStyle(color: Colors.grey, fontSize: deviceDiagonal * 0.020),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.020,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: LColors.primary,
                                          padding: EdgeInsets.only(right: deviceWidth * 0.10, left: deviceWidth * 0.10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                                        ),
                                        child: const Text(LTexts.cancel),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          chatHistoryBloc.isLoadingController.add(true);
                                          await chatHistoryBloc.removeToken();
                                          //await googleUser.signOut();
                                          await FirebaseAuth.instance.signOut();
                                          if (!context.mounted) return;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const LoginScreen(),
                                              ));
                                          chatHistoryBloc.isLoadingController.add(false);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: LColors.primary,
                                            padding:
                                                EdgeInsets.only(right: deviceWidth * 0.10, left: deviceWidth * 0.10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                                            foregroundColor: Colors.white),
                                        child: StreamBuilder<bool>(
                                          stream: chatHistoryBloc.isLoadingStream,
                                          builder: (context, snapshot) {
                                            if(snapshot.data == true){
                                              return SizedBox(
                                                  width: deviceWidth * 0.050,
                                                  height: deviceHeight * 0.025,
                                                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2));
                                            }else{
                                              return const Text(
                                                LTexts.logOut,
                                                style: TextStyle(color: Colors.white),
                                              );
                                            }

                                          }
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: LColors.primary,
                        ),
                        SizedBox(width: deviceWidth * 0.020),
                        const Text(LTexts.logOut)
                      ],
                    ))
              ];
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(deviceDiagonal * 0.010),
        child: StreamBuilder(
            stream: chatHistoryBloc.databaseReference1.onValue /*getChatHistoryListStream*/,
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
                                  width: deviceWidth * 0.60,
                                  height: deviceHeight * 0.015,
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.010,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(deviceDiagonal * 0.010))),
                                  width: deviceWidth * 0.40,
                                  height: deviceHeight * 0.012,
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.010,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(deviceDiagonal * 0.010))),
                                  width: deviceWidth * 0.20,
                                  height: deviceHeight * 0.010,
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
              } else {
                Map<dynamic, dynamic> chatData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                List<Map<dynamic, dynamic>> chatUsers = [];
                chatData.forEach((key, value) {
                  Map<dynamic, dynamic> chatUser = value;
                  chatUser['key'] = key;
                  chatUsers.add(chatUser);
                });
                return ListView.separated(
                  itemCount: chatUsers.length,
                  itemBuilder: (context, index) {
                    Map chatUser = chatUsers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(userData: chatUser),
                          ),
                        );
                      },
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              surfaceTintColor: Colors.white,
                              title: const Text(
                                "Delete",
                                style: TextStyle(color: LColors.primary),
                              ),
                              content:  Text("Are you sure you want to delete your Chat History with ${chatUser['sender_name']}?"),
                              actions: [
                                TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("CANCEL", style: TextStyle(color: LColors.primary))),
                                GestureDetector(
                                  onTap: () {
                                    chatHistoryBloc.databaseReference.child("chatHistory")
                                        .child(FirebaseAuth.instance.currentUser!.uid)
                                        .child(chatUser['senderId'])
                                        .remove();
                                    String allChat = chatHistoryBloc.firebaseUser + "_" + chatUser['senderId'];

                                    chatHistoryBloc.databaseChat.child(allChat).remove();
                                    Navigator.pop(context);
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
                        child: Column(
                          children: [
                            Container(
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
                                      child: Image.network(chatUser['image'], fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.040,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chatUser['sender_name'],
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        chatUser['last_message'],
                                        style: TextStyle(fontSize: deviceDiagonal * 0.020),
                                      ),
                                      Text(
                                        chatUser['time'],
                                        style: TextStyle(fontSize: deviceDiagonal * 0.015),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LColors.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const ChatUser();
            },
          ));
        },
        child: const Icon(
          Icons.add_comment_sharp,
          color: Colors.white,
        ),
      ),
    );
  }


}
