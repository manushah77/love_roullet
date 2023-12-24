import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:love_roulette/screens/BottomNavigationBar/bottom_bar.dart';

import '../../Constant/color.dart';
import '../../Models/user_data.dart';
import '../../Widegts/custom_btn.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String DatedMemberName;
  final String DatingMemberName;
  final String DatedMemberImage;
  final String DatingMemberImage;
  final String DatedMemberId;
  final String DatingMemberId;
  final String DateBudget;
  final String DateDestination;
  final String DateTheme;
  final String vhicle;
  final String BillPaidBy;
  final DateTime SelectedDate;
  final String DatingPointKM;

  final String age;
  final String gender;
  double latLocation;
  double longLocation;

  NotificationDetailScreen({
    Key? key,
    required this.age,
    required this.gender,
    required this.DateTheme,
    required this.DatedMemberId,
    required this.DatingMemberName,
    required this.DatingMemberId,
    required this.DateBudget,
    required this.BillPaidBy,
    required this.DateDestination,
    required this.DatingPointKM,
    required this.DatedMemberImage,
    required this.DatedMemberName,
    required this.DatingMemberImage,
    required this.SelectedDate,
    required this.vhicle,
    required this.latLocation,
    required this.longLocation,
  }) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  UserData? userData;

  String? cname;
  String? cage;
  String? cgender;
  String? cimg;
  String? cimgTwo;
  String? cId;

  List<Placemark>? placemark;
  final user = FirebaseAuth.instance.currentUser!;

  getLocation() async {
    placemark = await placemarkFromCoordinates(
      widget.latLocation.toDouble(),
      widget.longLocation.toDouble(),
    );
  }

  getData() async {
    // if (user != null) {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: user.uid)
        .get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          userData =
              UserData.fromMap(res.docs.first.data() as Map<String, dynamic>);

          cimg = '${userData!.imageOne}';
          cimgTwo = '${userData!.imageTwo}';
          cname = userData!.name;
          cage = '${userData!.age!}';
          cgender = userData!.gender;
          cId = userData!.id;

          // latitue = userData!.latituelocation;
          // longitute = userData!.longitudelocation;
          getLocation();
        }
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  DateTime _selectedDate = DateTime.now();
  bool isSelected = false;
  bool isSelected1 = false;
  bool isSelected2 = false;

  bool isPayBill = false;
  bool isPayBill1 = false;
  bool isPayBill2 = false;

  bool? isViechle;

  int day1 = 1;
  int day2 = 2;

  final formKey = GlobalKey<FormState>();

  String? selectedValue;
  String? selectedDate;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime selectedDated = DateTime.now();
  DateTime? picked;

  Future<void> _selectDate(BuildContext context) async {
    picked = await showDatePicker(
        context: context,
        initialDate: selectedDated,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 20));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked.toString();
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                height: 430,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/red.png'),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              left: 60,
                              child: Image.asset(
                                'assets/images/heart.png',
                                scale: 5.6,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 70.0),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.white30,
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundImage: NetworkImage(
                                    '${widget.DatingMemberImage}',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 120.0, top: 70),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.white30,
                                child: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 75,
                                  backgroundImage: NetworkImage(
                                    widget.DatedMemberImage,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Color(0xffF2F3F4).withOpacity(0.09),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.DatingMemberName}',
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ),
                        Text(
                          '&',
                          style: GoogleFonts.palanquin(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textScaleFactor: 1.0,
                        ),
                        Container(
                          height: 40,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Color(0xffF2F3F4).withOpacity(0.09),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              widget.DatedMemberName,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Congratulation',
                style: GoogleFonts.montserrat(
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'it\'s a ',
                    style: GoogleFonts.montserrat(
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textScaleFactor: 1.0,
                  ),
                  Text(
                    'Match',
                    style: GoogleFonts.montserrat(
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'If they also swipe right then it\'s match!',
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),

              SizedBox(
                height: 20,
              ),

              //location

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Text(
                      'Location',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor.withOpacity(0.6),
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .where(
                    'id',
                    isEqualTo: widget.DatedMemberId,
                  )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final sc = snapshot.data;

                      widget.latLocation = sc!.docs[0].get('latituelocation');
                      widget.longLocation = sc.docs[0].get('longitudelocation');
                      getLocation();

                      return SizedBox(
                        width: screenWidtg / 1.1,
                        height: 70,
                        child: TextFormField(
                          readOnly: true,

                          cursorColor: Colors.white,
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          // ignore: body_might_complete_normally_nullable
                          validator: (value) {},

                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixIconColor: whiteColor,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            border: InputBorder.none,
                            hintText: placemark == null
                                ? 'Your Location is'
                                : '${placemark![0].street}  , ${placemark![0].subAdministrativeArea} , ${placemark![0].locality}, ${placemark![0].administrativeArea}, ${placemark![0].country}',
                            hintStyle: GoogleFonts.openSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.2),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: Icon(
                              Icons.my_location_outlined,
                              color: whiteColor,
                              size: 19,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  }),

              //date theme

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Text(
                      'Date Theme',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor.withOpacity(0.6),
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screenWidtg /1.12,
                height: 70,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Enter DateTheme';
                    }
                  },
                  readOnly: true,
                  // controller: dateThemeC,
                  decoration: InputDecoration(
                    suffixIconColor: whiteColor,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    border: InputBorder.none,
                    hintText: widget.DateTheme,
                    hintStyle: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    filled: true,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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


              //date buddget

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Text(
                      'Date Budget',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor.withOpacity(0.6),
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screenWidtg /1.12,
                height: 70,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Enter DateBudget';
                    }
                  },
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  // controller: dateThemeC,
                  decoration: InputDecoration(
                    suffixIconColor: whiteColor,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    border: InputBorder.none,
                    hintText: widget.DateBudget,
                    hintStyle: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    filled: true,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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


              //calender

              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0, right: 27),
                    child: Text(
                      'Calender',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor.withOpacity(0.6),
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 230,
                    decoration: BoxDecoration(
                      color:Color(0xff601015),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.SelectedDate.day}',
                          style: GoogleFonts.openSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: whiteColor,
                          ),
                          textScaleFactor: 1.0,
                        ),
                        Text(
                          '${DateFormat('EEEE').format(widget.SelectedDate)}',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: whiteColor.withOpacity(0.6),
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: 20,
              ),
              //meeting point from your location

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Text(
                      'Metting Point From Your Location',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor.withOpacity(0.6),
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                width: screenWidtg /1.12,
                height: 70,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Enter Date Meeting Point';
                    }
                  },
                  readOnly: true,
                  // controller: dateMettingC,
                  decoration: InputDecoration(
                    suffixIconColor: whiteColor,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    border: InputBorder.none,
                    hintText: widget.DatingPointKM,
                    hintStyle: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                        color: Colors.white,
                    ),
                    filled: true,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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


              SizedBox(
                height: 10,
              ),

              //own vichle

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Text(
                      'Have Your Own Vichle',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor.withOpacity(0.6),
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                    height: 60,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                          widget.vhicle == false ? 'No': 'Yes',
                        style: GoogleFonts.openSans(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: whiteColor,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                    
                ],
              ),
              SizedBox(
                height: 20,
              ),

              // who wil pay

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Text(
                      // 'Who Will Pay?',
                      'Personal Description',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor.withOpacity(0.6),
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                width: screenWidtg /1.12,
                height: 70,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Enter Date Meeting Point';
                    }
                  },
                  readOnly: true,
                  // controller: dateMettingC,
                  maxLines: 3, //grow automatically
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    suffixIconColor: whiteColor,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    border: InputBorder.none,
                    hintText: widget.BillPaidBy,
                    hintStyle: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    filled: true,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
              SizedBox(
                height: 30,
              ),
              CustomButton(
                txt: 'Back',
                ontap: () async {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
