import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_roulette/Models/accepted_model.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:love_roulette/screens/BottomNavigationBar/BottomBarScreens/inbox/chat_screen_complete.dart';
import 'package:love_roulette/screens/SignUpScreen/Auth_code/auth_code.dart';

import '../Models/messege.dart';
import '../Widegts/date_time_util.dart';

class ChatUserCard extends StatefulWidget {
  AcceptedDateData userData;
  Messges? messges;


  ChatUserCard({Key? key, required this.userData,this.messges}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Messges? messges;
  List<AcceptedDateData> userData = [];

  String? datingMemberId;
  String? datedMemberId;
  final user = FirebaseAuth.instance.currentUser!.uid;

  getData() async {
    // if (user != null) {
    QuerySnapshot res =
    await FirebaseFirestore.instance.collection('ContactCollection').get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          userData = res.docs
              .map((e) =>
              AcceptedDateData.fromMap(e.data() as Map<String, dynamic>))
              .toList();

          for (var item in userData) {
            datingMemberId = item.DatingMemberId!;
            datedMemberId = item.DatedMemberId!;

            // Use the retrieved IDs as desired
            print('DatingMemberId: $datingMemberId');
            print('DatedMemberId: $datedMemberId');
            print('zxczxczxczcz: ${FirebaseAuth.instance.currentUser!.uid+datedMemberId!}');

          }
        }
      });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff1A1A1A).withOpacity(0.8),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .04, vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // color: Colors.pink.withOpacity(0.4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreenNew(
                acceptUser: widget.userData,
              ),
            ),
          );
        },
        child: StreamBuilder(
            stream: AuthWork.getLastMessage(widget.userData),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final _list =
                  data?.map((e) => Messges.fromJson(e.data())).toList() ?? [];

              if (_list.isNotEmpty) {
                messges = _list[0];
              }

              return ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffFFE2A9),
                      width: 1.5,
                    ),
                    shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .10),
                    child: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      imageUrl:  "${widget.userData.DatedMemberImage}",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '${widget.userData.DatedMemberName}',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '${messges != null ? messges!.type == Typee.image ? 'Image' : messges!.msg : widget.userData.DatedMemberGender}',
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    color: Colors.white38,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: messges == null
                    ? null
                    : messges!.read!.isEmpty &&
                            messges!.fromId != AuthWork.user.uid
                        ? Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: '${messges!.sent}'),
                            style: GoogleFonts.openSans(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                          ),
              );
            }),
      ),
    );
  }
}
