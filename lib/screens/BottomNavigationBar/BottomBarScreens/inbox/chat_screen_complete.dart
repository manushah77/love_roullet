import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love_roulette/Constant/color.dart';
import 'package:love_roulette/Models/accepted_model.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:love_roulette/Widegts/custom_text_field.dart';
import 'package:love_roulette/chat_widget/messege_card.dart';
import 'package:love_roulette/screens/SignUpScreen/Auth_code/auth_code.dart';

import '../../../../Models/messege.dart';
import '../../../../Widegts/date_time_util.dart';

class ChatScreenNew extends StatefulWidget {
  final AcceptedDateData? acceptUser;

  const ChatScreenNew({
    Key? key,
    this.acceptUser,
  }) : super(key: key);

  @override
  State<ChatScreenNew> createState() => _ChatScreenNewState();
}

class _ChatScreenNewState extends State<ChatScreenNew> {
  Messges? messges;
  List<Messges> _list = [];
  TextEditingController msg = TextEditingController();
  ScrollController _scrollController = ScrollController();

  bool isUploading = false;
  bool showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (showEmoji) {
            setState(() {
              showEmoji = !showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          // resizeToAvoidBottomInset : false,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: primaryColor,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: _appBar(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: AuthWork.getAllMessages(widget.acceptUser!),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return SizedBox();

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          //
                          _list = data
                                  ?.map((e) => Messges.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height * .01),
                                itemCount: _list.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessgeCard(
                                    messegs: _list[index],
                                  );
                                });
                          } else {
                            return Center(
                              child: Text(
                                'Say Hii.. 👋',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                      }
                    }),
              ),

              //uploadig image

              if (isUploading)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Container(
                      width: 35,
                      height: 35,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              chatInput(),
              if (showEmoji)
                SizedBox(
                  height: MediaQuery.of(context).size.height * .35,
                  child: EmojiPicker(
                    textEditingController: msg,
                    // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      backspaceColor: Colors.white,
                      columns: 8,
                      emojiSizeMax: 32 *
                          (Platform.isIOS
                              ? 1.30
                              : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return StreamBuilder(
      stream: AuthWork.getUserInfo(widget.acceptUser!),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        // final list =
        //     data?.map((e) => AcceptedDateData.fromMap(e.data())).toList() ?? [];

        return Row(
          children: [
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/images/back.png',
                scale: 1.5,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffFFE2A9),
                    width: 1.5,
                  ),
                  shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .1),
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                  imageUrl:"${widget.acceptUser!.DatedMemberImage}",
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) => SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 3,
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
               '${widget.acceptUser!.DatedMemberName}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 4,
                ),

              ],
            )
          ],
        );
      },
    );
  }

  Widget chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      showEmoji = !showEmoji;
                    });
                  },
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 100),
                      child: TextFormField(
                        scrollController: _scrollController,
                        cursorColor: Colors.white,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        controller: msg,
                        onTap: () {
                          if (showEmoji) {
                            setState(() {
                              showEmoji = !showEmoji;
                            });
                          }
                        },
                        maxLines: null, //grow automatically
                        keyboardType: TextInputType.multiline,
                        cursorHeight: 17,
                        decoration: InputDecoration(
                          suffixIconColor: whiteColor,
                          contentPadding:
                              EdgeInsets.only(top: 10, left: 16, right: 16),
                          border: InputBorder.none,
                          hintText: 'Type Your Text here...',
                          hintStyle: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white38,
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            minWidth: 43,
            height: 43,
            color: primaryColor,
            shape: CircleBorder(),
            onPressed: () {

              if (msg.text.trim().isNotEmpty) {
                if (_list.isEmpty) {
                  AuthWork.sendFirstMessage(widget.acceptUser!, msg.text, Typee.text);
                } else {
                  AuthWork.sendMessage(widget.acceptUser!, msg.text, Typee.text);
                }
                msg.text = '';
              }



            },
            child: Center(
              child: Icon(
                Icons.send,
                color: whiteColor,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
