// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:love_roulette/screens/SignUpScreen/add_photos_screen.dart';
// import 'package:love_roulette/screens/SignUpScreen/continue_screen.dart';
// import 'package:love_roulette/screens/SignUpScreen/signup_screen.dart';
//
// import '../../Constant/color.dart';
// import '../../Widegts/custom_btn.dart';
//
// class DobScreen extends StatefulWidget {
//   const DobScreen({Key? key}) : super(key: key);
//
//   @override
//   State<DobScreen> createState() => _DobScreenState();
// }
//
// class _DobScreenState extends State<DobScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 20.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ContinueScreen(),
//                         ),
//                       );
//                     },
//                     child: Image.asset(
//                       'assets/images/back.png',
//                       scale: 1.5,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 40.w,
//                   ),
//                   Text(
//                     'Step 2 of 4',
//                     style: GoogleFonts.openSans(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white54,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 100.w,
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 22.0),
//                     child: Text(
//                       'When is your\n birthday?',
//                       style: GoogleFonts.openSans(
//                         fontSize: 38.sp,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     'Day',
//                     style: GoogleFonts.openSans(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       color: whiteColor.withOpacity(0.6),
//                     ),
//                   ),
//                   Text(
//                     'Month',
//                     style: GoogleFonts.openSans(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       color: whiteColor.withOpacity(0.6),
//                     ),
//                   ),
//                   Text(
//                     'Year',
//                     style: GoogleFonts.openSans(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       color: whiteColor.withOpacity(0.6),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(
//                     width: 100.w,
//                     height: 80.h,
//                     child: TextFormField(
//                       cursorColor: Colors.white,
//                       style: GoogleFonts.openSans(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                       ),
//                       // ignore: body_might_complete_normally_nullable
//                       validator: (value) {},
//                       keyboardType: TextInputType.number,
//                       maxLength: 2,
//                       decoration: InputDecoration(
//                         suffixIconColor: whiteColor,
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 5),
//                         border: InputBorder.none,
//                         hintText: '01',
//                         hintStyle: GoogleFonts.openSans(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey.withOpacity(0.3),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 100.w,
//                     height: 80.h,
//                     child: TextFormField(
//                       cursorColor: Colors.white,
//                       style: GoogleFonts.openSans(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                       ),
//                       // ignore: body_might_complete_normally_nullable
//                       validator: (value) {},
//                       keyboardType: TextInputType.number,
//                       maxLength: 2,
//                       decoration: InputDecoration(
//                         suffixIconColor: whiteColor,
//                         contentPadding:
//                         EdgeInsets.symmetric(horizontal: 40, vertical: 5),
//                         border: InputBorder.none,
//                         hintText: '01',
//                         hintStyle: GoogleFonts.openSans(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey.withOpacity(0.3),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 100.w,
//                     height: 80.h,
//                     child: TextFormField(
//                       cursorColor: Colors.white,
//                       style: GoogleFonts.openSans(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white,
//                       ),
//                       // ignore: body_might_complete_normally_nullable
//                       validator: (value) {},
//                       keyboardType: TextInputType.number,
//                       maxLength: 4,
//                       decoration: InputDecoration(
//                         suffixIconColor: whiteColor,
//                         contentPadding:
//                         EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//                         border: InputBorder.none,
//                         hintText: '1900',
//                         hintStyle: GoogleFonts.openSans(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey.withOpacity(0.3),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 23.0),
//                     child: Text(
//                       'Location',
//                       style: GoogleFonts.openSans(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w500,
//                         color: whiteColor.withOpacity(0.6),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               SizedBox(
//                 width: 330.w,
//                 height: 70.h,
//                 child: TextFormField(
//                   readOnly: true,
//                   cursorColor: Colors.white,
//                   style: GoogleFonts.openSans(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white,
//                   ),
//                   // ignore: body_might_complete_normally_nullable
//                   validator: (value) {
//                   },
//
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     suffixIconColor: whiteColor,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
//                     border: InputBorder.none,
//                     hintText: 'Rafi Garden SWL',
//                     hintStyle: GoogleFonts.openSans(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.white,
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.withOpacity(0.2),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                     suffixIcon: Icon(Icons.my_location_outlined,color: whiteColor,size: 19,),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20.h,
//               ),
//               CustomButton(
//                 txt: 'Continue',
//                 ontap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddPhotoScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
