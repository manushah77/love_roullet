import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:love_roulette/screens/BottomNavigationBar/bottom_bar.dart';

import '../../Constant/color.dart';
import '../../Models/user_data.dart';
import '../../Widegts/custom_btn.dart';
import '../../Widegts/notification_class.dart';
import 'package:http/http.dart' as http;

class MatchingScreen extends StatefulWidget {
  final String name;
  final String img;
  final String id;
  final String age;
  final String token;
  final String gender;
  double latLocation;
  double longLocation;

  MatchingScreen({
    Key? key,
    required this.name,
    required this.img,
    required this.latLocation,
    required this.longLocation,
    required this.id,
    required this.token,
    required this.age,
    required this.gender,
  }) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
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

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;


  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

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
          cage = userData!.age!;
          cgender = userData!.gender;
          cId = userData!.id;

          // latitue = userData!.latituelocation;
          // longitute = userData!.longitudelocation;
          getLocation();
        }
      });
  }

  TextEditingController dateThemeC = TextEditingController();
  TextEditingController dateBudgetC = TextEditingController();
  TextEditingController dateMettingC = TextEditingController();
  TextEditingController personalDescriptionC = TextEditingController();
  ScrollController _scrollController = ScrollController();


  final formKey = GlobalKey<FormState>();
  NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getConnectivity();
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    // services.RefreshgetDeviceToken();

    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMsg(context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
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

  _storeValue(String value) async {
    try {
      await firestore.collection('Date').doc(widget.id+cId!).set({
        "DatingMemberName": cname,
        "DatedMemerName": widget.name,
        "DatedMemerImage": widget.img,
        "DatingMemerImage": cimg,
        "DatingMemerGender": cgender.toString(),
        "DatingMemberAge": '${cage}',
        "LatitueDatedMember": widget.latLocation,
        "LongituteDatedMember": widget.longLocation,
        "DateTheme": dateThemeC.text.toString(),
        'DateBudget': dateBudgetC.text.toString(),
        "SelectedDayForDate": selectedDated.toString(),
        "YourDistanceFromDp": dateMettingC.text.toString(),
        'Vichle': isViechle.toString(),
        'PayBy': personalDescriptionC.text.toString(),
        'DatingMemberId': cId,
        'DatedMemberId': widget.id,
        'DatedMemberAge': widget.age,
        'DatedMemberGender': widget.gender,
      }).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBar(selectedIndex: 0,),
          ),
        );

      });
      print('Value stored in Firebase: $value');
    } catch (e) {
      print('Error storing value: $e');
    }
  }

  _storeValuetwo(String value) async {
    try {
      await firestore.collection('Notification').doc(widget.id + cId!).set({
        "DatingMemberName": cname,
        "DatedMemerName": widget.name,
        "DatedMemerImage": widget.img,
        "DatingMemerImage": cimg,
        "LatitueDatedMember": widget.latLocation,
        "LongituteDatedMember": widget.longLocation,
        "DateTheme": dateThemeC.text.toString(),
        'DateBudget': dateBudgetC.text.toString(),
        "SelectedDayForDate": selectedDate.toString(),
        "YourDistanceFromDp": dateMettingC.text.toString(),
        'Vichle': isViechle.toString(),
        'PayBy': value,
        'DatingMemberId': cId,
        'DatedMemberId': widget.id,
        'DatedMemberAge': widget.age,
        'DatedMemberGender': widget.gender,
      });
      print('Value stored in Firebase: $value');
    } catch (e) {
      print('Error storing value: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return WillPopScope(
     onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBar(selectedIndex: 0,),
                ),
              );
            },
            child: Image.asset(
              'assets/images/back.png',
              scale: 1.5,
            ),
          ),
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
                                      '${cimg}',
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
                                      widget.img,
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
                                '${cname}',
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
                                widget.name,
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
                          isEqualTo: widget.id,
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
                    controller: dateThemeC,
                    decoration: InputDecoration(
                      suffixIconColor: whiteColor,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      border: InputBorder.none,
                      hintText: 'The Pearl Continel IND',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white38,
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
                    controller: dateBudgetC,
                    decoration: InputDecoration(
                      prefix: Text('\$ ',style : GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      ),) ,
                      suffixIconColor: whiteColor,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      border: InputBorder.none,
                      hintText: '\$0 - \$100',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white38,
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
                    // Row(
                    //   children: [
                    //     Text(
                    //       '( Show calender )',
                    //       style: GoogleFonts.openSans(
                    //         fontSize: 11,
                    //         fontWeight: FontWeight.w500,
                    //         color: whiteColor.withOpacity(0.6),
                    //       ),                      ),
                    //     IconButton(
                    //         onPressed: () {
                    //           _selectDate(context);
                    //         },
                    //         icon: Icon(Icons.calendar_month),
                    //         color: Color.fromARGB(251, 138, 133, 132)),
                    //   ],
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        if (isSelected == true) {
                          setState(() {
                            isSelected = false;
                          });
                          selectedValue = '${_selectedDate.day}';
                        } else {
                          setState(() {
                            isSelected = true;
                            isSelected1 = false;
                            isSelected2 = false;
                          });
                        }
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected == true
                              ? Color(0xff601015)
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_selectedDate.day}',
                              style: GoogleFonts.openSans(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: whiteColor,
                              ),
                              textScaleFactor: 1.0,
                            ),
                            Text(
                              '${DateFormat('EEEE').format(_selectedDate)}',
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
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        if (isSelected1 == true) {
                          setState(() {
                            isSelected1 = false;
                          });
                          selectedValue = '${_selectedDate.add(
                                Duration(days: 1),
                              ).day}';
                        } else {
                          setState(() {
                            isSelected1 = true;
                            isSelected = false;
                            isSelected2 = false;
                          });
                        }
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected1 == true
                              ? Color(0xff601015)
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_selectedDate.add(
                                    Duration(days: 1),
                                  ).day}',
                              style: GoogleFonts.openSans(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: whiteColor,
                              ),
                              textScaleFactor: 1.0,
                            ),
                            Text(
                              '${DateFormat('EEEE').format(
                                _selectedDate.add(
                                  Duration(days: 1),
                                ),
                              )}',
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
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        if (isSelected2 == true) {
                          setState(() {
                            isSelected2 = false;
                          });
                          selectedValue = '${_selectedDate.add(
                                Duration(days: 2),
                              ).day}';
                        } else {
                          setState(() {
                            isSelected2 = true;
                            isSelected1 = false;
                            isSelected = false;
                          });
                        }
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected2 == true
                              ? Color(0xff601015)
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_selectedDate.add(
                                    Duration(days: 2),
                                  ).day}',
                              style: GoogleFonts.openSans(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: whiteColor,
                              ),
                              textScaleFactor: 1.0,
                            ),
                            Text(
                              '${DateFormat('EEEE').format(
                                _selectedDate.add(
                                  Duration(days: 2),
                                ),
                              )}',
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
                    controller: dateMettingC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffix: Text('km',style : GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),) ,
                      suffixIconColor: whiteColor,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      border: InputBorder.none,
                      hintText: '20-km',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white38,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isViechle = false;
                        });
                        // Fluttertoast.showToast(
                        //     msg: "No, I have No Vichle",
                        //     gravity: ToastGravity.CENTER,
                        //     backgroundColor: primaryColor,
                        //     textColor: Colors.white,
                        //     fontSize: 16.0);
                      },
                      child: isViechle == false
                          ? Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'No',
                                  style: GoogleFonts.openSans(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              color: Colors.white,
                              radius: Radius.circular(30),
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    'No',
                                    style: GoogleFonts.openSans(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isViechle = true;
                        });
                        // Fluttertoast.showToast(
                        //     msg: "Yes, I have a Vichle",
                        //     gravity: ToastGravity.CENTER,
                        //     backgroundColor: primaryColor,
                        //     textColor: Colors.white,
                        //     fontSize: 16.0);
                      },
                      child: isViechle == true
                          ? Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Yes',
                                  style: GoogleFonts.openSans(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              color: Colors.white,
                              radius: Radius.circular(30),
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    'Yes',
                                    style: GoogleFonts.openSans(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
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

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         selectedValue = '$cname';
                //
                //         if (isPayBill == true) {
                //           selectedValue = '$cname';
                //
                //           setState(() {
                //             isPayBill = false;
                //           });
                //         } else {
                //           setState(() {
                //             isPayBill = true;
                //             isPayBill1 = false;
                //             isPayBill2 = false;
                //           });
                //         }
                //         // _storeValue(selectedValue!);
                //         // Fluttertoast.showToast(
                //         //     msg: "Bill will be paid by $cname",
                //         //     gravity: ToastGravity.CENTER,
                //         //     backgroundColor: primaryColor,
                //         //     textColor: Colors.white,
                //         //     fontSize: 16.0);
                //       },
                //       child: DottedBorder(
                //         borderType: BorderType.RRect,
                //         color: Colors.white,
                //         radius: Radius.circular(30),
                //         child: Container(
                //           height: 50,
                //           width: 100,
                //           decoration: BoxDecoration(
                //             color: isPayBill == true
                //                 ? Colors.grey
                //                 : Colors.grey.withOpacity(0.3),
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //           child: Center(
                //             child: Text(
                //               '$cname',
                //               style: GoogleFonts.openSans(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w600,
                //                 color: whiteColor,
                //               ),
                //               textAlign: TextAlign.center,
                //               textScaleFactor: 1.0,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: () {
                //         selectedValue = widget.name;
                //
                //         if (isPayBill1 == true) {
                //           selectedValue = widget.name;
                //
                //           setState(() {
                //             isPayBill1 = false;
                //           });
                //         } else {
                //           setState(() {
                //             isPayBill = false;
                //             isPayBill1 = true;
                //             isPayBill2 = false;
                //           });
                //         }
                //         // Fluttertoast.showToast(
                //         //     msg: "Bill will be paid by ${widget.name}",
                //         //     gravity: ToastGravity.CENTER,
                //         //     backgroundColor: primaryColor,
                //         //     textColor: Colors.white,
                //         //     fontSize: 16.0);
                //       },
                //       child: DottedBorder(
                //         borderType: BorderType.RRect,
                //         color: Colors.white,
                //         radius: Radius.circular(30),
                //         child: Container(
                //           height: 50,
                //           width: 100,
                //           decoration: BoxDecoration(
                //             color: isPayBill1 == true
                //                 ? Colors.grey
                //                 : Colors.grey.withOpacity(0.3),
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //           child: Center(
                //             child: Text(
                //               widget.name,
                //               style: GoogleFonts.openSans(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w600,
                //                 color: whiteColor,
                //               ),
                //               textAlign: TextAlign.center,
                //               textScaleFactor: 1.0,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: () {
                //         selectedValue = 'Split';
                //
                //         if (isPayBill2 == true) {
                //           selectedValue = 'Split';
                //
                //           setState(() {
                //             isPayBill2 = false;
                //           });
                //         } else {
                //           setState(() {
                //             isPayBill = false;
                //             isPayBill1 = false;
                //             isPayBill2 = true;
                //           });
                //         }
                //         // _storeValue(selectedValue!);
                //         // Fluttertoast.showToast(
                //         //     msg: "Bill will be paid by Split",
                //         //     gravity: ToastGravity.CENTER,
                //         //     backgroundColor: primaryColor,
                //         //     textColor: Colors.white,
                //         //     fontSize: 16.0);
                //       },
                //       child: DottedBorder(
                //         borderType: BorderType.RRect,
                //         color: Colors.white,
                //         radius: Radius.circular(30),
                //         child: Container(
                //           height: 50,
                //           width: 100,
                //           decoration: BoxDecoration(
                //             color: isPayBill2 == true
                //                 ? Colors.grey
                //                 : Colors.grey.withOpacity(0.3),
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //           child: Center(
                //             child: Text(
                //               'Split',
                //               style: GoogleFonts.openSans(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w600,
                //                 color: whiteColor,
                //               ),
                //               textScaleFactor: 1.0,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  width: screenWidtg /1.12,
                  height: 85,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    // ignore: body_might_complete_normally_nullable
                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Enter Personal Description';
                      }
                    },
                    maxLines: null, //grow automatically
                    keyboardType: TextInputType.multiline,
                    controller: personalDescriptionC,
                    decoration: InputDecoration(

                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      border: InputBorder.none,
                      hintText: 'Personal Description',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white38,
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
                  txt: 'Continue',
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      // final User user = auth.currentUser!;
                      // _storeValue(selectedValue!);
                      await FirebaseFirestore.instance
                          .collection('Date')
                          .doc(widget.id+cId!)
                          .set({
                        "DatingMemberName": cname,
                        "DatedMemerName": widget.name,
                        "DatedMemerImage": widget.img,
                        "DatingMemerImage": cimg,
                        "DatingMemerGender": cgender.toString(),
                        "DatingMemberAge": '${cage}',
                        "LatitueDatedMember": widget.latLocation,
                        "LongituteDatedMember": widget.longLocation,
                        "DateTheme": dateThemeC.text.toString(),
                        'DateBudget': dateBudgetC.text.toString(),
                        "SelectedDayForDate": selectedDated.toString(),
                        "YourDistanceFromDp": dateMettingC.text.toString(),
                        'Vichle': isViechle.toString(),
                        'PayBy': personalDescriptionC.text.toString(),
                        'DatingMemberId': cId,
                        'DatedMemberId': widget.id,
                        'DatedMemberAge': widget.age,
                        'DatedMemberGender': widget.gender,
                        'like': false,
                        'token': widget.token,
                      }).then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomBar(selectedIndex: 0,),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          content: Text(
                            "Date SuccessFully Submit",
                            style: TextStyle(color: primaryColor, fontSize: 19),
                          ),
                          duration: Duration(seconds: 2),
                        ));
                        notificationServices.getDeviceToken().then((value) async {
                          var data = {
                            'to': widget.token,
                            'priority': 'high',
                            'notification': {
                              'title': 'Love Roulette',
                              'body': 'Congratulations! You have been selected by $cname',
                              'android_channel_id': 'dating_app'
                            },
                            'data': {'id': '1111122'}
                          };

                          var headers = {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Authorization':
                            'key=AAAA8E2XqVo:APA91bFWCF82WN-6vL0jxzkwkyXa3Yro80uckwKZDUw7kvP8id4ZfmDCkV0zyvhBATMmr1juqa2KqyEBv8S8zDewG_-HVentd0iwb6FZSldie9JGeRXpTTmCuUyRnPcT1ZdEFujRWiDc'
                          };

                          var response = await http.post(
                            Uri.parse('https://fcm.googleapis.com/fcm/send'),
                            body: jsonEncode(data),
                            headers: headers,
                          );

                          // Check if the notification was sent successfully
                          if (response.statusCode == 200) {
                            // Notification sent successfully
                            print('Notification sent successfully');
                          } else {
                            // Notification failed to send
                            print('Failed to send notification. Response status code: ${response.statusCode}');
                          }
                        });

                      });




                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
