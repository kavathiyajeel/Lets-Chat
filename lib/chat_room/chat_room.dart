import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:lets_chat/utils/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../image_viewer/image_viewer.dart';
import '../utils/contains.dart';
import '../utils/size.dart';
import 'chat_room_bloc.dart';

class ChatRoom extends StatefulWidget {
  final Map userData;

  const ChatRoom({super.key, required this.userData});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  late ChatRoomBloc chatRoomBloc;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        _onDetached();
      case AppLifecycleState.resumed:
        _onResumed();
      case AppLifecycleState.inactive:
        _onInactive();
      case AppLifecycleState.hidden:
        _onHidden();
      case AppLifecycleState.paused:
        _onPaused();
    }
  }

  void _onDetached() => debugPrint(' ===== detached');

  void _onResumed() {
    chatRoomBloc.addUserStatus(status: true);
    debugPrint(' ===== resumed');
  }

  void _onInactive() => debugPrint(' ===== inactive');

  void _onHidden() => debugPrint('=====hidden');

  void _onPaused() {
    chatRoomBloc.addUserStatus(status: false);
    debugPrint('=====paused');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    chatRoomBloc = ChatRoomBloc(context, widget.userData);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    chatRoomBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatRoomBloc.userDatabaseReference.onValue,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              elevation: 3,
              shadowColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.black),
              leading:
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_sharp)),
              title: StreamBuilder(
                  stream: chatRoomBloc.userDatabaseReference.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      dynamic data = snapshot.data!.snapshot.value;
                      chatRoomBloc.mobileNumber = data["mobile_number"];
                      return GestureDetector(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                                  insetPadding: EdgeInsets.all(deviceDiagonal * 0.040),
                                  backgroundColor: Colors.transparent,
                                  surfaceTintColor: Colors.transparent,
                                  child: Container(
                                      margin: EdgeInsets.all(deviceDiagonal * 0.020),
                                      padding: EdgeInsets.all(deviceDiagonal * 0.030),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(deviceDiagonal * 0.015)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () => Navigator.pop(context),
                                                icon: Icon(
                                                  CupertinoIcons.clear_circled_solid,
                                                  color: LColors.primary,
                                                  size: deviceDiagonal * 0.050,
                                                )),
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.01,
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.white38,
                                            radius: deviceDiagonal * 0.08,
                                            backgroundImage: NetworkImage(data["image"]),
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.01,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Name : ",
                                                style: TextStyle(color: Colors.black, fontSize: deviceDiagonal * 0.025),
                                              ),
                                              Text(
                                                data["full_name"],
                                                style: TextStyle(
                                                  color: LColors.primary,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: deviceDiagonal * 0.025,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.01,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Email : ",
                                                style: TextStyle(color: Colors.black, fontSize: deviceDiagonal * 0.025),
                                              ),
                                              Text(
                                                data["email"],
                                                style: TextStyle(
                                                    color: LColors.primary,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: deviceDiagonal * 0.025),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.01,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Mobile Number : ",
                                                style: TextStyle(color: Colors.black, fontSize: deviceDiagonal * 0.025),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  data["mobile_number"],
                                                  maxLines: 5,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: LColors.primary,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: deviceDiagonal * 0.025),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.01,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "About Me : ",
                                                style: TextStyle(color: Colors.black, fontSize: deviceDiagonal * 0.025),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  data["about_me"],
                                                  maxLines: 5,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: LColors.primary,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: deviceDiagonal * 0.025),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                );
                              });
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white38,
                              backgroundImage: NetworkImage(widget.userData["image"]),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.030,
                            ),
                            Text(
                              widget.userData["full_name"] ?? widget.userData["sender_name"],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: deviceWidth * 0.030,
                            ),
                            Container(
                              height: deviceHeight * 0.030,
                              width: deviceWidth * 0.40,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(deviceDiagonal * 0.020)),
                            )
                          ],
                        ),
                      );
                    }
                  }),
              actions: [
                GestureDetector(
                  onTap: () async {
                    debugPrint("mobile_number is ${chatRoomBloc.mobileNumber}");
                    String? number = chatRoomBloc.mobileNumber;
                    var url = Uri.parse('tel:$number');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: IconButton(
                      style: IconButton.styleFrom(foregroundColor: LColors.primary),
                      onPressed: null,
                      icon: const Icon(
                        Icons.phone,
                        color: LColors.primary,
                      )),
                )
              ],
            ),
            body: SafeArea(
              minimum: EdgeInsets.all(deviceDiagonal * 0.010),
              child: Column(
                children: [
                  Expanded(
                      child: StreamBuilder(
                    stream: chatRoomBloc.databaseReference1.onValue,
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
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: deviceHeight * 0.010),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(deviceDiagonal * 0.020),
                                                  topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topRight: Radius.circular(deviceDiagonal * 0.020))),
                                          width: deviceWidth * 0.20,
                                          height: deviceHeight * 0.070,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: deviceHeight * 0.010),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topRight: Radius.circular(deviceDiagonal * 0.020))),
                                          width: deviceWidth * 0.20,
                                          height: deviceHeight * 0.070,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: deviceHeight * 0.010),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(deviceDiagonal * 0.020),
                                                  topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topRight: Radius.circular(deviceDiagonal * 0.020))),
                                          width: deviceWidth * 0.40,
                                          height: deviceHeight * 0.070,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: deviceHeight * 0.010),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topRight: Radius.circular(deviceDiagonal * 0.020))),
                                          width: deviceWidth * 0.60,
                                          height: deviceHeight * 0.3,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: deviceHeight * 0.010),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(deviceDiagonal * 0.020),
                                                  topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topRight: Radius.circular(deviceDiagonal * 0.020))),
                                          width: deviceWidth * 0.70,
                                          height: deviceHeight * 0.070,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: deviceHeight * 0.010),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topRight: Radius.circular(deviceDiagonal * 0.020))),
                                          width: deviceWidth * 0.40,
                                          height: deviceHeight * 0.070,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: deviceHeight * 0.010),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(deviceDiagonal * 0.020),
                                                  topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                  topRight: Radius.circular(deviceDiagonal * 0.020))),
                                          width: deviceWidth * 0.60,
                                          height: deviceHeight * 0.3,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.hasError.toString()),
                        );
                      } else if (snapshot.data?.snapshot.value == null) {
                        return GestureDetector(
                          onTap: () {
                            chatRoomBloc.sendMessage();
                            chatRoomBloc.chatHistory("Hello! 👋");
                            chatRoomBloc.sendNotifications("Hello! 👋");
                          },
                          child: Center(
                              child: Text(
                            "Say Hello! 👋",
                            style: TextStyle(color: LColors.primary, fontSize: deviceDiagonal * 0.040),
                          )),
                        );
                      } else {
                        return FirebaseAnimatedList(
                          query: chatRoomBloc.databaseReference1,
                          sort: (DataSnapshot a, DataSnapshot b) => b.key!.compareTo(a.key!),
                          reverse: true,
                          itemBuilder: (context, snapshot, animation, index) {
                            Map chat = snapshot.value as Map;
                            chat[key] = snapshot.key;
                            String chatUser = widget.userData["uid"] ?? widget.userData["senderId"];
                            return chat["type"] == "text"
                                ? Row(
                                    mainAxisAlignment: (chatUser == chat["senderId"])
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: deviceDiagonal * 0.004,
                                          ),
                                          padding: EdgeInsets.only(
                                              top: deviceHeight * 0.01,
                                              bottom: deviceHeight * 0.010,
                                              right: deviceWidth * 0.023,
                                              left: deviceWidth * 0.023),
                                          decoration: BoxDecoration(
                                            color: (chatUser == chat["senderId"])
                                                ? LColors.primary.withOpacity(0.60)
                                                : LColors.primary.withOpacity(0.9),
                                            borderRadius: chatUser == chat["senderId"]
                                                ? BorderRadius.only(
                                                    bottomRight: Radius.circular(deviceDiagonal * 0.020),
                                                    topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                    topRight: Radius.circular(deviceDiagonal * 0.020))
                                                : BorderRadius.only(
                                                    bottomLeft: Radius.circular(deviceDiagonal * 0.020),
                                                    topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                    topRight: Radius.circular(deviceDiagonal * 0.020)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: (chatUser == chat["senderId"])
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                chat["message"],
                                                style: TextStyle(color: Colors.white, fontSize: deviceDiagonal * 0.030),
                                              ),
                                              Text(
                                                chat["time"],
                                                style: TextStyle(color: Colors.white, fontSize: deviceDiagonal * 0.015),
                                              ),
                                            ],
                                          )),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: (chatUser == chat["senderId"])
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) => ImageViewer(link: chat["message"]));
                                        },
                                        child: Container(
                                            height: deviceHeight * 0.30,
                                            width: deviceWidth * 0.55,
                                            margin: EdgeInsets.only(bottom: deviceHeight * 0.004),
                                            padding: EdgeInsets.only(
                                                top: deviceHeight * 0.01,
                                                bottom: deviceHeight * 0.010,
                                                right: deviceWidth * 0.023,
                                                left: deviceWidth * 0.023),
                                            decoration: BoxDecoration(
                                              color: (chatUser == chat["senderId"])
                                                  ? LColors.primary.withOpacity(0.60)
                                                  : LColors.primary.withOpacity(0.9),
                                              borderRadius: chatUser == chat["senderId"]
                                                  ? BorderRadius.only(
                                                      bottomRight: Radius.circular(deviceDiagonal * 0.020),
                                                      topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                      topRight: Radius.circular(deviceDiagonal * 0.020))
                                                  : BorderRadius.only(
                                                      bottomLeft: Radius.circular(deviceDiagonal * 0.020),
                                                      topLeft: Radius.circular(deviceDiagonal * 0.020),
                                                      topRight: Radius.circular(deviceDiagonal * 0.020)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: (chatUser == chat["senderId"])
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  height: deviceHeight * 0.25,
                                                  width: deviceWidth * 0.50,
                                                  child: chat["message"] != null
                                                      ? ClipRRect(
                                                          borderRadius: BorderRadius.circular(deviceDiagonal * 0.020),
                                                          child: Image.network(
                                                            chat["message"],
                                                            filterQuality: FilterQuality.high,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (context, child, loadingProgress) {
                                                              if (loadingProgress == null) {
                                                                return child;
                                                              } else {
                                                                return const Center(
                                                                    child: CircularProgressIndicator(
                                                                  color: Colors.white,
                                                                  strokeWidth: 2,
                                                                ));
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      : const CircularProgressIndicator(
                                                          color: Colors.white, strokeWidth: 2),
                                                ),
                                                SizedBox(
                                                  height: deviceHeight * 0.008,
                                                ),
                                                Text(
                                                  chat["time"],
                                                  style:
                                                      TextStyle(color: Colors.white, fontSize: deviceDiagonal * 0.015),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  );
                          },
                        );
                      }
                    },
                  )),
                  SizedBox(
                    height: deviceHeight * 0.010,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: LColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(deviceDiagonal * 0.020))),
                    // color: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      children: [
                        Flexible(
                            child: TextField(
                          cursorColor: LColors.primary,
                          controller: chatRoomBloc.messageController,
                          maxLines: null,
                          decoration: const InputDecoration(border: InputBorder.none, hintText: "Enter Message"),
                        )),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    margin: EdgeInsets.all(deviceDiagonal * 0.020),
                                    child: Row(children: [
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: LColors.primary,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                chatRoomBloc.imgFromGallery();
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
                                                chatRoomBloc.imgFromCamera();
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
                                    ]),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.photo,
                              color: LColors.primary,
                            )),
                        GestureDetector(
                          onTap: () {
                            if (chatRoomBloc.messageController.text.isNotEmpty) {
                              chatRoomBloc.isButtonEnabled = true;
                              chatRoomBloc.sendMessage();
                              chatRoomBloc.chatHistory(chatRoomBloc.messageController.text.toString());
                              chatRoomBloc.sendNotifications(chatRoomBloc.messageController.text.toString());
                            }
                          },
                          child: const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.send,
                                color: LColors.primary,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
