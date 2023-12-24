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

import '../../../../Constant/color.dart';
import '../../../../Models/accepted_model.dart';
import '../../../../Models/date_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<AcceptedDateData> userData = [];

  String? cname;
  String? cage;
  String? cgender;
  String? cimg;

  String? dname;
  String? dage;
  String? dgender;
  String? dimg;

  String? cimgTwo;
  String? cId;
  double? latitue;
  double? longitute;

  List<Placemark>? placemark;
  final user = FirebaseAuth.instance.currentUser!;

  getLocation() async {
    placemark = await placemarkFromCoordinates(
      latitue!.toDouble(),
      longitute!.toDouble(),
    );
  }
  String? datingMemberId;
  String? datedMemberId;

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
        .collection('Accepted')
    // .where('DocId', isEqualTo: '${datedMemberId!+datingMemberId!}')
        .where('DatedMemberId', isEqualTo: user.uid)
        .get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          userData = res.docs
              .map((e) => AcceptedDateData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
          cname = userData[0].DatingMemberName;
          cId = userData[0].DatingMemberId!;
          cimg = userData[0].DatingMemberImage;
          cage = userData[0].DatingMemberAge.toString();
          cgender = userData[0].DatingMemberGender.toString();

          latitue = userData[0].LatitueDatedMember;
          longitute = userData[0].LongituteDatedMember;
          getLocation();
          for (var item in userData) {
            datingMemberId = item.DatingMemberId!;
            datedMemberId = item.DatedMemberId!;

            // Use the retrieved IDs as desired
            print('DatingMemberId: $datingMemberId');
            print('DatedMemberId: $datedMemberId');

            print('aaaaaaaaa: $cgender');
            print('wwwwwww: $cname');
            print('wwwwwwwwwwwwwww : $cage');
            print('wwwwwwwwwwwwwww : $cId');
          }
        }
      });
  }

  getDataTwo() async {
    // if (user != null) {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('Accepted')
    // .where('DocId', isEqualTo: '${datedMemberId!+datingMemberId!}')
        .where('DatingMemberId', isEqualTo: user.uid)
        .get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          userData = res.docs
              .map((e) => AcceptedDateData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
          dname = userData[0].DatingMemberName;
          dimg = userData[0].DatingMemberImage;
          dage = userData[0].DatingMemberAge.toString();
          dgender = userData[0].DatingMemberGender.toString();

          latitue = userData[0].LatitueDatedMember;
          longitute = userData[0].LongituteDatedMember;
          getLocation();
          for (var item in userData) {
            datingMemberId = item.DatingMemberId!;
            datedMemberId = item.DatedMemberId!;

          }
        }
      });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    getData();
    getDataTwo();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => exit(0),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Previous Dates',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: whiteColor,
            ),
            textScaleFactor: 1.0,
          ),
        ),
        body: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover),
            ),
            child:
            userData.isEmpty
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
                      'No Previous\n Date Found',
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
                :Column(
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
                        Color likeColor = userData[index].like == true
                            ? Colors.blue
                            : Colors.white60;

                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 10),
                          child: AspectRatio(
                            aspectRatio: 1.6 / .6,
                            child: Container(
                              height: 120,
                              width: 320,
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
                                      width: screenWidtg / 3.4,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: datedMemberId == user.uid
                                                ? NetworkImage(
                                              '${userData[index].DatingMemberImage}',
                                            )
                                                : NetworkImage(
                                              '${userData[index].DatedMemberImage}',
                                            ),
                                            fit: BoxFit.cover,
                                          )),
                                    ),

                                    SizedBox(
                                      width: screenWidtg / 1.9,
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
                                                datedMemberId == user.uid
                                                    ? Expanded(
                                                      child: Text(
                                                  '${userData[index].DatingMemberName}',
                                                  style: GoogleFonts
                                                        .openSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      color: Colors
                                                          .white,
                                                  ),
                                                  textScaleFactor:
                                                  1.0,
                                                  overflow:
                                                  TextOverflow
                                                        .ellipsis,
                                                        maxLines: 1,
                                                ),
                                                    )
                                                    : Expanded(
                                                      child: Text(
                                                  '${userData[index].DatedMemberName}',
                                                  style: GoogleFonts
                                                        .openSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      color: Colors
                                                          .white,
                                                  ),
                                                  textScaleFactor:
                                                  1.0,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                ),
                                                    ),
                                                SizedBox(
                                                  width: 45,
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
                                                        ? '---------- ----- -----'
                                                        : ' ${placemark![0].administrativeArea},${placemark![0].country}',
                                                    style: GoogleFonts
                                                        .openSans(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                    textScaleFactor: 1.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                userData[index].DatingMemberGender ==
                                                    'Male' ||   userData[index].DatedMemberGender ==
                                                    'Male'
                                                    ? Icon(
                                                  Icons.male,
                                                  color:
                                                  Colors.white,
                                                  size: 10,
                                                )
                                                    : Icon(
                                                  Icons.female,
                                                  color:
                                                  Colors.white,
                                                  size: 10,
                                                ),

                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: datedMemberId == user.uid
                                                      ?  Text(
                                                    userData[index].DatingMemberGender == null ||  userData[index].DatingMemberGender!.isEmpty  ? '----------' :
                                                    '${userData[index].DatingMemberGender}',
                                                    style: GoogleFonts
                                                        .openSans(
                                                      fontSize: 10,
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                    textScaleFactor:
                                                    1.0,
                                                  )
                                                      : Text(
                                                    userData[index].DatedMemberGender == null ||  userData[index].DatedMemberGender!.isEmpty  ? '----------' :

                                                    '${userData[index].DatedMemberGender}',
                                                    style: GoogleFonts
                                                        .openSans(
                                                      fontSize: 10,
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                    textScaleFactor:
                                                    1.0,
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
                                                datedMemberId == user.uid
                                                    ? Text(
                                                  userData[index].DatingMemberAge == null ||  userData[index].DatingMemberAge!.isEmpty  ? '----------' :
                                                  '${userData[index].DatingMemberAge} Years Old',
                                                  style: GoogleFonts
                                                      .openSans(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                  textScaleFactor:
                                                  1.0,
                                                )
                                                    : Text(
                                                  userData[index].DatedMemberAge == null ||  userData[index].DatedMemberAge!.isEmpty  ? '----------' :
                                                  '${userData[index].DatedMemberAge} Years Old',
                                                  style: GoogleFonts
                                                      .openSans(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                  textScaleFactor:
                                                  1.0,
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
                                    //thumb up
                                    GestureDetector(
                                      onTap: () {

                                        userData[index].like == false ?
                                        {
                                          setState(() {
                                            userData[index]
                                                .like = !userData[
                                            index]
                                                .like!; // Toggle the liked state
                                          }),
                                          FirebaseFirestore.instance
                                              .collection('Accepted')
                                              .doc(userData[index]
                                              .DatedMemberId! +
                                              user.uid)
                                              .update({
                                            "like": true,
                                          })
                                        } :
                                        {
                                          setState(() {
                                            userData[index]
                                                .like = !userData[
                                            index]
                                                .like!; // Toggle the liked state
                                          }),
                                          FirebaseFirestore.instance
                                              .collection('Accepted')
                                              .doc(userData[index]
                                              .DatedMemberId! +
                                              user.uid)
                                              .update({
                                            "like": false,
                                          })
                                        };


                                        //dislike



                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.grey
                                                  .withOpacity(0.3),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons
                                                    .thumb_up_off_alt_outlined,
                                                color: likeColor,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
      ),
    );
  }


}
