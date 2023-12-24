import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constant/color.dart';
import '../screens/SignUpScreen/continue_screen.dart';

class CustomButton extends StatefulWidget {
  final String? txt;
  final Function ontap;

  CustomButton({Key? key, this.txt, required this.ontap}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        widget.ontap();
      },
      child: Container(
        height: screenHeight / 12.5,
        width: screenWidtg / 1.66,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFFB90),
              Color(0xffFBE978),
              Color(0xffF8DC65),
              Color(0xffE6C758),
              Color(0xffC49F40),
              Color(0xffAC832F),
              Color(0xffAC832F),
              Color(0xff9E7225),
              Color(0xff9E7225),
              Color(0xff996C22),
              Color(0xff9D7125),
              Color(0xffA98030),
              Color(0xffBD9A42),
              Color(0xffD9BE5A),
              Color(0xffD9BE5A),
              Color(0xffFBE878),
              Color(0xffFFFFAA),
              Color(0xffFBE878),
              Color(0xffA4631B),


            ],
          ),
        ),
        child: Container(
          height: screenHeight / 13.8,
          width: screenWidtg / 1.72,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${widget.txt}',
              style: GoogleFonts.openSans(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: whiteColor,
              ),
              textScaleFactor: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
