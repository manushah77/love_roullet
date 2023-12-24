import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../Constant/color.dart';
import '../../../../Models/tags.dart';

class SelectedUserProfileScreen extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final String img;
  final String imgTwo;
  final String id;
  double latitue;

  double longitute;

  SelectedUserProfileScreen({
    Key? key,
    required this.name,
    required this.age,
    required this.gender,
    required this.img,
    required this.imgTwo,
    required this.latitue,
    required this.longitute,
    required this.id,
  }) : super(key: key);

  @override
  State<SelectedUserProfileScreen> createState() =>
      _SelectedUserProfileScreenState();
}

class _SelectedUserProfileScreenState extends State<SelectedUserProfileScreen> {
  final PageController controller = PageController();
  List<Placemark>? placemark;
  UserData? userdata;
  bool isLoading = false;
  List<UserData> tags = [];


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
        .where('id', isEqualTo: widget.id)
        .get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          // userdata =
          //     UserData.fromMap(res.docs.first.data() as Map<String, dynamic>);

          getLocation();
        }
      });
    // tags

    QuerySnapshot rest = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: widget.id)
        .get();
    if (rest.docs.isNotEmpty)
      setState(() {
        {
          tags = rest.docs
              .map((e) => UserData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
        }
      });

  }

  getLocation() async {
    placemark = await placemarkFromCoordinates(
      widget.latitue.toDouble(),
      widget.longitute.toDouble(),
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getConnectivity();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    List imageUrls = [
      widget.img,
      widget.imgTwo,
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/images/back.png',
            scale: 1.5,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 450,
                  child: PageView.builder(
                    controller: controller,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      if (imageUrls == null) {
                        Image.asset('assets/images/men.png');
                      } else {
                        imageUrls[index];
                      }
                      return CachedNetworkImage(
                        height: 430,
                        width: double.infinity,
                        imageUrl: '${imageUrls[index]}',
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              color: Colors.white,
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  top: 370,
                  // left: 140,
                  child: Align(
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: imageUrls.length,
                      effect: ExpandingDotsEffect(
                          activeDotColor: Colors.white,
                          dotColor: Colors.white60,
                          strokeWidth: 10,
                          dotHeight: 8,
                          dotWidth: 15),
                    ),
                  ),
                ),
                // Positioned(
                //   left: 17,
                //   top: 45,
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: Image.asset(
                //       'assets/images/back.png',
                //       scale: 1.5,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text(
                    widget.name.toString(),
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textScaleFactor: 1.0,

                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 15,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 13,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    placemark == null
                        ? 'Your Location is'
                        : '${placemark![0].administrativeArea}, ${placemark![0].country}',
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textScaleFactor: 1.0,

                  ),
                  SizedBox(
                    width: 75,
                  ),
                  widget.gender == 'Male'
                      ? Icon(
                          Icons.male,
                          color: Colors.white,
                          size: 15,
                        )
                      : Icon(
                          Icons.female,
                          color: Colors.white,
                          size: 15,
                        ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    widget.gender.toString(),
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textScaleFactor: 1.0,

                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/pin.png',
                    scale: 4.5,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${widget.age} Years Old',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textScaleFactor: 1.0,

                  ),
                  SizedBox(
                    width: 100,
                  ),
                  // Icon(
                  //   Icons.monetization_on_outlined,
                  //   color: Colors.white,
                  //   size: 18,
                  // ),
                  // SizedBox(
                  //   width: 5.w,
                  // ),
                  // Text(
                  //   '\$200',
                  //   style: GoogleFonts.openSans(
                  //     fontSize: 16.sp,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text(
                    'Hobbies',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Wrap(
              children: [
                if(tags.isNotEmpty)
                  for( int i =0; i<tags[0].tags!.length;i++)
                    ChoicePickChip(
                      title: '${tags[0].tags![i]}',
                    ),


              ],
            ),          ],
        ),
      ),
    );
  }
}
class ChoicePickChip extends StatefulWidget {
  String? title;

  ChoicePickChip({
    Key? key,
    this.title,
    // this.icon,
  }) : super(key: key);

  @override
  State<ChoicePickChip> createState() => _ChoicePickChipState();
}

class _ChoicePickChipState extends State<ChoicePickChip> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7, top: 5),
      child: ChoiceChip(
        label: Wrap(
          children: [
            // Image.asset(
            //   '',
            //   scale: 5,
            //   color: Colors.white,
            // ),
            SizedBox(
              width: 5,
            ),
            Text(
              '${widget.title}',
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        onSelected: (isSelected) {},
        selected: false,
      ),
    );
  }
}