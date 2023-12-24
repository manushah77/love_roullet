import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:love_roulette/screens/SignUpScreen/add_photos_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/signup_screen.dart';

import '../../Constant/color.dart';
import '../../Widegts/custom_btn.dart';
import '../../Widegts/map_page.dart';

class ContinueScreen extends StatefulWidget {
  const ContinueScreen({Key? key}) : super(key: key);

  @override
  State<ContinueScreen> createState() => _ContinueScreenState();
}

class _ContinueScreenState extends State<ContinueScreen> {
  TextEditingController ageC = TextEditingController();
  TextEditingController heightC = TextEditingController();
  TextEditingController heightInchC = TextEditingController();

  TextEditingController weightC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  double? latitue;
  double? longitute;
  List<Placemark>? placemark;

  getLocation() async {
    placemark = await placemarkFromCoordinates(
      latitue!.toDouble(),
      longitute!.toDouble(),
    );
  }

  UserData? userData;
  final user = FirebaseAuth.instance.currentUser!;

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
    void showbottomsheet() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 230,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text(
                            'Ft',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            height: 120,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return 'Enter Ft';
                                }
                              },
                              controller: heightC,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 5, left: 20, right: 20, bottom: 5),
                                border: InputBorder.none,
                                hintText: '1',
                                hintStyle: GoogleFonts.openSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38,
                                ),
                                filled: true,
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.white24,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                counter: Offstage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Inches',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 70,
                            height: 120,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value == '' || value == null) {
                                  return 'Enter Inches';
                                }
                              },
                              controller: heightInchC,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counter: Offstage(),
                                contentPadding: EdgeInsets.only(
                                    top: 5, left: 20, right: 20, bottom: 5),
                                border: InputBorder.none,
                                hintText: '1',
                                hintStyle: GoogleFonts.openSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38,
                                ),
                                filled: true,
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.white24,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: 40,
                    width: 100,
                    child: Material(
                      color: Colors.transparent,
                      child: CustomButton(
                        ontap: () {
                          Navigator.pop(context);
                        },
                        txt: 'Ok',
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      );
    }

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      // onTap: () {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             SignUpScreen()), // Replace "HomeScreen()" with your app's home screen.
                      //   );
                      // },
                      child: Image.asset(
                        'assets/images/back.png',
                        scale: 1.5,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Step 1 of 3',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Age & Height.',
                        style: GoogleFonts.openSans(
                          fontSize: 38,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0),
                      child: Text(
                        'Age',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
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
                  width: screenWidtg / 1.12,
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
                      if (value == '' || value == null) {
                        return 'Enter Age';
                      }
                    },
                    controller: ageC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIconColor: whiteColor,
                      contentPadding: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 5),
                      border: InputBorder.none,
                      hintText: 'Age',
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

                //height

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0),
                      child: Text(
                        'Height',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
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
                  width: screenWidtg / 1.12,
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
                      // if (value == '' || value == null) {
                      //   return 'Enter Height';
                      // }
                    },
                    readOnly: true,
                    onTap: () {
                      showbottomsheet();
                    },

                    controller: TextEditingController(
                        text: '${heightC.text} ft ${heightInchC.text} inches'),
                    decoration: InputDecoration(
                      suffixIconColor: whiteColor,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      border: InputBorder.none,
                      hintText: 'Height',
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

                //weight

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0),
                      child: Text(
                        'Weight',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
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
                  width: screenWidtg / 1.12,
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
                      if (value == '' || value == null) {
                        return 'Enter Weight';
                      }
                    },
                    controller: weightC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIconColor: whiteColor,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      border: InputBorder.none,
                      hintText: 'Weight',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0),
                      child: Text(
                        'Location',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
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
                        .where('id',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sc = snapshot.data;

                        latitue = sc!.docs[0].get('latituelocation');
                        longitute = sc.docs[0].get('longitudelocation');
                        getLocation();

                        return SizedBox(
                          width: screenWidtg / 1.12,
                          height: 70,
                          child: TextFormField(
                            readOnly: true,
                            cursorColor: Colors.white,
                            style: GoogleFonts.openSans(
                              fontSize: 13,
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
                              suffixIcon: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomGoogleMap(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.my_location_outlined,
                                  color: whiteColor,
                                  size: 19,
                                ),
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

                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  txt: 'Continue',
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      final time =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        final documentReference = await FirebaseFirestore
                            .instance
                            .collection('user')
                            .doc(user.uid);
                        userData = UserData(
                            name: userData!.name,
                            email: userData!.email,
                            id: user.uid,
                            age: ageC.text.toString(),
                            height:
                                '${heightC.text} ft ${heightInchC.text} inches',
                            weight: double.parse(weightC.text.toString()),
                            imageOne: '',
                            imageTwo: '',
                            flower: 5,
                            haveCar: '',
                            dataComplete:'notComplete',

                            pushToken: userData!.pushToken,
                            maximumSpend: 0,
                            minimumSpend: 0,
                            gender: '',
                            latituelocation: latitue,
                            longitudelocation: longitute,
                            createdAt: time,
                            isOnline: false,
                            lastActive: time,
                            timestamp: Timestamp.fromDate(DateTime.now()),
                            tags: []);
                        // await documentReference.id;
                        await documentReference.update(userData!.toMap()).then(
                          (value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddPhotoScreen()), // Replace "HomeScreen()" with your app's home screen.
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                content: Text(
                                  "Age Section Added SuccessFully",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      }
                      throw FormatException('Errors');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
