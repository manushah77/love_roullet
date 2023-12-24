import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:love_roulette/screens/BottomNavigationBar/BottomBarScreens/inbox/chat_screen_complete.dart';
import 'package:love_roulette/screens/BottomNavigationBar/bottom_bar.dart';

import '../../../../Constant/color.dart';
import '../../../../Models/date_model.dart';
import '../../Models/accepted_model.dart';
import 'notifcation_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  AcceptedDateData? acceptedDateData;
  // bool showAlert = false;


  NotificationScreen({this.acceptedDateData, });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<DatedData> userData = [];
  List<AcceptedDateData> acceptedModel = [];

  String? cname;
  String? cage;
  String? cgender;
  String? cimg;
  String? cimgTwo;
  String? cId;
  double? latitue;
  double? longitute;

  bool? alert;
  bool? alertTwo;


  List<Placemark>? placemark;
  final user = FirebaseAuth.instance.currentUser!;

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

  getLocation() async {
    placemark = await placemarkFromCoordinates(
      latitue!.toDouble(),
      longitute!.toDouble(),
    );
  }

  getData() async {
    // if (user != null) {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('Date')
        .where('DatedMemberId', isEqualTo: user.uid)
        .get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          userData = res.docs
              .map((e) => DatedData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
          cname = userData[0].DatingMemberName;
          cId = userData[0].DatingMemberId;
          cimg = userData[0].DatingMemerImage;
          cage = userData[0].DatingMemberAge.toString();
          cgender = userData[0].DatingMemberGender.toString();

          latitue = userData[0].LatitueDatedMember;
          longitute = userData[0].LongituteDatedMember;

          alert = userData[0].Accepted;
          alertTwo = userData[0].Rejected;

          getLocation();
        }
      });
    if(alert != null) {
      showAlert(alert == true ? false : true );
    }

    // print(userData[0].DatedMemberId);
    // print('user .......');
    // print(user.uid);
    //2nd

    // if (user != null) {
    QuerySnapshot rest = await FirebaseFirestore.instance
        .collection('ContactCollection')
    // .where('DatedMemberId', isNotEqualTo: user.uid)
    // .where('DatingMemberId', isEqualTo: user.uid)
        .get();
    if (rest.docs.isNotEmpty)
      setState(() {
        {
          acceptedModel = rest.docs
              .map((e) =>
              AcceptedDateData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
        }
      });
    // print(cname);

  }

  showAlert (bool show) {
    if (userData.isNotEmpty) {
      if (userData[0].Accepted == false && userData[0].Rejected == false ) {
        showAlertDialog();
      }
    }
  }

  showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Congratulation"),
        content: Text('You have been selected for a date'),
        actions: [
          TextButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop(); // dismiss dialog
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(userData.isNotEmpty) {
    //   if(widget.showAlert == true) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) async {
    //       showAlertDialog();
    //     });
    //
    //   }
    // }

    getData();
    getConnectivity();
    // showAlert(alert == true ? false : true);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Notification',
          style: GoogleFonts.montserrat(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
          textScaleFactor: 1.0,
        ),
      ),
      body: userData.isEmpty
          ? Center(
        child: Container(
          height: 300,
          width: 270,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: whiteColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/nodate.png',
                height: 200,
                width: 200,
              ),
              Text(
                'No Notification Found',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textScaleFactor: 1.0,
              ),
            ],
          ),
        ),
      )
          : Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      Color likeColor = userData[index].Accepted == true
                          ? Colors.green
                          : Colors.white;

                      Color likeColors = userData[index].Rejected == true
                          ? Colors.red
                          : Colors.white;

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10),
                        child: AspectRatio(
                          aspectRatio: 1.6 / .6,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationDetailScreen(
                                        age: userData[index]
                                            .DatedMemberAge
                                            .toString(),
                                        gender: userData[index]
                                            .DatedMemberGender
                                            .toString(),
                                        DateTheme: userData[index]
                                            .DateTheme
                                            .toString(),
                                        DatedMemberId: userData[index]
                                            .DatedMemberId
                                            .toString(),
                                        DatingMemberName: userData[index]
                                            .DatingMemberName
                                            .toString(),
                                        DatingMemberId: userData[index]
                                            .DatingMemberId
                                            .toString(),
                                        DateBudget: userData[index]
                                            .DateBudget
                                            .toString(),
                                        BillPaidBy:
                                        userData[index].PayBy.toString(),
                                        DateDestination: userData[index]
                                            .DateTheme
                                            .toString(),
                                        DatingPointKM: userData[index]
                                            .YourDistanceFromDp
                                            .toString(),
                                        DatedMemberImage: userData[index]
                                            .DatedMemerImage
                                            .toString(),
                                        DatedMemberName: userData[index]
                                            .DatedMemerName
                                            .toString(),
                                        DatingMemberImage: userData[index]
                                            .DatingMemerImage
                                            .toString(),
                                        SelectedDate: DateTime.parse(
                                            userData[index]
                                                .SelectedDayForDate
                                                .toString()),
                                        vhicle:
                                        userData[index].Vichle.toString(),
                                        latLocation: double.parse(
                                            userData[index]
                                                .LatitueDatedMember
                                                .toString()),
                                        longLocation: double.parse(
                                            userData[index]
                                                .LongituteDatedMember
                                                .toString()),
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 120,
                              width: 318,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white60,
                                      spreadRadius: 0.9,
                                      blurRadius: 1),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 130,
                                      width: screenWidtg / 3.52,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              '${userData[index].DatingMemerImage}',
                                            ),
                                            fit: BoxFit.cover,
                                          )),
                                    ),

                                    SizedBox(
                                      width: screenWidtg / 2.1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${userData[index].DatingMemberName}',
                                                    style: GoogleFonts
                                                        .openSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                    textScaleFactor: 1.0,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .location_on_outlined,
                                                  color: Colors.white,
                                                  size: 11,
                                                ),
                                                // SizedBox(
                                                //   width: 1,
                                                // ),
                                                FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: Text(
                                                    placemark == null
                                                        ? 'Your Location is'
                                                        : ' ${placemark![0].locality},${placemark![0].country}',
                                                    style: GoogleFonts
                                                        .openSans(
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color: Colors.white,
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
                                              children: [
                                                Image.asset(
                                                  'assets/icons/pin.png',
                                                  scale: 6,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${userData[index].DatingMemberAge} Years Old',
                                                  style: GoogleFonts
                                                      .openSans(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                  textScaleFactor: 1.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: screenWidtg / 15,
                                    // ),

                                    //accepted

                                    userData[index].Accepted == true ||
                                        userData[index].Rejected ==
                                            true
                                        ? Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            try {
                                              setState(() {
                                                userData[index]
                                                    .Accepted =
                                                !userData[index]
                                                    .Accepted!; // Toggle the liked state
                                                userData[index]
                                                    .Rejected =
                                                false;
                                              });
                                              Navigator
                                                  .pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BottomBar(
                                                            selectedIndex:
                                                            2,
                                                          )));
                                            } catch (e) {
                                              throw Exception(e);
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Container(
                                                height: 30,
                                                width: 45,
                                                decoration:
                                                BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                      0.3),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      8),
                                                ),
                                                child: Center(
                                                  child: userData[index]
                                                      .Accepted ==
                                                      true ||
                                                      userData[index]
                                                          .Rejected ==
                                                          false
                                                      ? Text(
                                                    'Accepted',
                                                    style:
                                                    TextStyle(
                                                      color:
                                                      likeColor,
                                                      fontSize:
                                                      10,
                                                    ),
                                                    textScaleFactor:
                                                    1.0,
                                                  )
                                                      : Text(
                                                    'Rejected',
                                                    style:
                                                    TextStyle(
                                                      color: Colors
                                                          .red,
                                                      fontSize:
                                                      10,
                                                    ),
                                                    textScaleFactor:
                                                    1.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                        : Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              userData[index]
                                                  .Accepted =
                                              !userData[index]
                                                  .Accepted!; // Toggle the liked state
                                              userData[index]
                                                  .Rejected = false;
                                            });

                                            //collections fucntion

                                            collectionFunction(index);

                                            Navigator
                                                .pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                        BottomBar(
                                                          selectedIndex: 2,
                                                        )));
                                            // Navigator.pop(context);
                                          },
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Container(
                                                height: 30,
                                                width: 45,
                                                decoration:
                                                BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                      0.3),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Accepted',
                                                    style:
                                                    TextStyle(
                                                      color:
                                                      likeColor,
                                                      fontSize: 10,
                                                    ),
                                                    textScaleFactor:
                                                    1.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              userData[index]
                                                  .Rejected =
                                              !userData[index]
                                                  .Rejected!; // Toggle the liked state

                                              userData[index]
                                                  .Accepted = false;
                                            });

                                            FirebaseFirestore
                                                .instance
                                                .collection('Date')
                                                .doc(user.uid +
                                                userData[index]
                                                    .DatingMemberId!)
                                            // .doc(userData[index]
                                            //         .DatedMemberId! +
                                            //     user.uid)
                                                .update({
                                              "Rejected": true,
                                              "Accepted": false,
                                            });

                                            // Navigator.pop(context);
                                          },
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Container(
                                                height: 30,
                                                width: 45,
                                                decoration:
                                                BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                      0.3),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      8),
                                                ),
                                                child: Center(
                                                  child: FittedBox(
                                                    fit: BoxFit
                                                        .scaleDown,
                                                    child: Text(
                                                      'Rejected',
                                                      style:
                                                      TextStyle(
                                                        color:
                                                        likeColors,
                                                        fontSize:
                                                        10,
                                                      ),
                                                      textScaleFactor:
                                                      1.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }


  collectionFunction (int index) async{
  try {
    FirebaseFirestore
        .instance
        .collection('Date')
        .doc(user.uid +
        userData[index]
            .DatingMemberId!)
        .update({
      "Accepted": true,
      "Rejected": false,
    });

    //add collection
    await FirebaseFirestore
        .instance
        .collection(
        'Accepted')
        .doc(userData[index]
        .DatedMemberId! +
        cId!)
        .set({
      "DatingMemberName":
      cname,
      "DatedMemberName":
      userData[index]
          .DatedMemerName!,
      "DatedMemberImage":
      userData[index]
          .DatedMemerImage!,
      "DatingMemberImage":
      cimg,
      "DatingMemberGender":
      userData[0]
          .DatedMemberGender!,
      "DatingMemberAge":
      '${cage}',
      "LatitueDatedMember":
      userData[index]
          .LatitueDatedMember!,
      "LongituteDatedMember":
      userData[index]
          .LongituteDatedMember!,
      "DateTheme":
      userData[index]
          .DateTheme!,
      'DateBudget':
      userData[index]
          .DateBudget!,
      "SelectedDayForDate":
      userData[index]
          .SelectedDayForDate!,
      "YourDistanceFromDp":
      userData[index]
          .YourDistanceFromDp!,
      'Vichle':
      userData[index]
          .Vichle!,
      'PayBy':
      userData[index]
          .PayBy!,
      'DatingMemberId': cId,
      'DocId':
      '${userData[index].DatedMemberId! + cId!}',
      'DatedMemberId':
      userData[index]
          .DatedMemberId!,
      'DatedMemberAge':
      userData[index]
          .DatedMemberAge!,
      'DatedMemberGender':
      userData[index]
          .DatedMemberGender!,
    });

    //add collection

    await FirebaseFirestore
        .instance
        .collection(
        'Accepted')
        .doc(cId! +
        userData[index]
            .DatedMemberId!)
        .set({
      "DatedMemberName":
      cname,
      "DatingMemberName":
      userData[index]
          .DatedMemerName!,
      "DatingMemberImage":
      userData[index]
          .DatedMemerImage!,
      "DatedMemberImage":
      cimg,
      "DatedMemberGender":
      userData[0]
          .DatedMemberGender!,
      "DatedMemberAge":
      '${cage}',
      "LatitueDatedMember":
      userData[index]
          .LatitueDatedMember!,
      "LongituteDatedMember":
      userData[index]
          .LongituteDatedMember!,
      "DateTheme":
      userData[index]
          .DateTheme!,
      'DateBudget':
      userData[index]
          .DateBudget!,
      "SelectedDayForDate":
      userData[index]
          .SelectedDayForDate!,
      "YourDistanceFromDp":
      userData[index]
          .YourDistanceFromDp!,
      'Vichle':
      userData[index]
          .Vichle!,
      'PayBy':
      userData[index]
          .PayBy!,
      'DatedMemberId': cId,
      'DocId':
      '${cId! + userData[index].DatedMemberId!}',
      'DatingMemberId':
      userData[index]
          .DatedMemberId!,
      'DatingMemberAge':
      userData[index]
          .DatedMemberAge!,
      'DatingMemberGender':
      userData[index]
          .DatingMemberGender!,
    });

    //Dated Person collection

    await FirebaseFirestore
        .instance
        .collection(
        'ContactCollection')
        .doc(userData[index]
        .DatedMemberId! +
        cId!)
        .set({
      "DatedMemberName":
      cname,
      "DatedMemberImage":
      cimg,
      'DatedMemberId': cId,
      "DatingMemberName":
      userData[index]
          .DatedMemerName!,
      "DatingMemberImage":
      userData[index]
          .DatedMemerImage!,
      'DocId':
      '${userData[index].DatedMemberId! + cId!}',
      'DatingMemberId':
      userData[index]
          .DatedMemberId!,
    });

    //Dating Person collection

    await FirebaseFirestore
        .instance
        .collection(
        'ContactCollection')
        .doc(cId! +
        userData[index]
            .DatedMemberId!)
        .set({
      "DatingMemberName":
      cname,
      "DatingMemberImage":
      cimg,
      // "DatingMemerGender": cgender.toString(),
      'DatingMemberId': cId,
      "DatedMemberName":
      userData[index]
          .DatedMemerName!,
      "DatedMemberImage":
      userData[index]
          .DatedMemerImage!,
      'DocId':
      '${cId! + userData[index].DatedMemberId!}',
      'DatedMemberId':
      userData[index]
          .DatedMemberId!,
      // 'DatedMemberGender': userData[index].DatedMemberGender!,
    });
  }

      catch(e) {
      throw Exception(e);
  }

}
}
