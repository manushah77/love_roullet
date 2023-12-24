import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_roulette/Constant/color.dart';
import 'package:love_roulette/screens/SignUpScreen/Auth_code/auth_code.dart';

import '../Models/messege.dart';
import '../Widegts/date_time_util.dart';

class MessgeCard extends StatefulWidget {
  final Messges messegs;

  const MessgeCard({Key? key, required this.messegs}) : super(key: key);

  @override
  State<MessgeCard> createState() => _MessgeCardState();
}

class _MessgeCardState extends State<MessgeCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = AuthWork.user.uid == widget.messegs.fromId;
    //
    return InkWell(
      onTap: () {
      },

      onLongPress: () {
        _showBottomSheet(isMe);
      },

      child: isMe ? _redMessege() : _blackMessege(),
    );
  }

  Widget _blackMessege() {
    //update read status yani blue tick ta ky pta lagy msg seen ho gya ky nai
    if (widget.messegs.read!.isEmpty) {
      AuthWork.updateMessageReadStatus(widget.messegs);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //body

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child:   Text(
                  '${widget.messegs.msg!.trim()}',
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.white
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: '${widget.messegs.sent}'),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        //double tick or msg time
        // Row(
        //   children: [
        //     SizedBox(
        //       width: 10,
        //     ),
        //     Text(
        //       MyDateUtil.getFormattedTime(
        //           context: context, time: '${widget.messegs.sent}'),
        //       style: TextStyle(fontSize: 13, color: Colors.white),
        //     ),
        //     SizedBox(
        //       width: 20,
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _redMessege() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //double tick or msg time

        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            if (widget.messegs.read!.isNotEmpty)
              Icon(
                Icons.check_outlined,
                color: Colors.transparent,
                size: 18,
              ),
          ],
        ),

        //body

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor,
                    width: 1,
                  ),
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),),
                ),
                child: Text(
                  '${widget.messegs.msg!.trim()}',
                  style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.white
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: '${widget.messegs.sent}'),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //bottom sheet


  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (_) {
          return ListView(
            padding: EdgeInsets.only(top: 15),
            shrinkWrap: true,
            children: [

              SizedBox(
                height: 10,
              ),
              if (isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    name: 'Delete Messege',
                    onTap: () async {
                      Navigator.pop(context);
                      await AuthWork.deleteMessage(widget.messegs).then((value) {
                        Dialogs.showSnakcbar(context, 'Deleted');
                      });
                    }),
              if (widget.messegs.type == Typee.text &&
                  isMe)
                SizedBox(
                  height: 10,
                ),

              SizedBox(
                height: 25,
              ),
            ],
          );
        });
  }



}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {Key? key, required this.icon, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                '  ${name}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class Dialogs {
  static void showSnakcbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: primaryColor.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showProgresbar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        )
      ),
    );
  }
}
