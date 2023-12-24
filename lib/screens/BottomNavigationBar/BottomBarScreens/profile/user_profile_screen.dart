import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:love_roulette/screens/BottomNavigationBar/BottomBarScreens/profile/profile_edit.dart';
import 'package:love_roulette/screens/LoginScreen/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../Constant/color.dart';
import '../../../../Models/tags.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final PageController controller = PageController();

  UserData? userData;
  List<UserData> tags = [];

  String? name;
  String? age;
  String? gender;
  String? maxSpend;
  String? haveCaar;
  String? img;
  String? imgTwo;
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

          img = '${userData!.imageOne}';
          imgTwo = '${userData!.imageTwo}';
          name = userData!.name;
          age = userData!.age;
          gender = userData!.gender;

          maxSpend = userData!.maximumSpend.toString();
          haveCaar = userData!.haveCar;

          latitue = userData!.latituelocation;
          longitute = userData!.longitudelocation;
          getLocation();
        }
      });

    // tags

    QuerySnapshot rest = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: user.uid)
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

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await DefaultCacheManager().emptyCache();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    getData();
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
      img,
      imgTwo,
    ];

    return WillPopScope(
      onWillPop: () async => exit(0),

      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: whiteColor,
            ),
            textScaleFactor: 1.0,
          ),
          actions: [
            IconButton(
              onPressed: () {
                signOut().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    content: Text(
                      "User logout SuccessFully",
                      style: TextStyle(color: primaryColor, fontSize: 19),
                    ),
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                });
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
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
                        if (imageUrls == '') {
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
                    // left: 150,
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
                  Positioned(
                    left: 17,
                    top: 85,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(
                              ag: age.toString(),
                              naaam: name.toString(),
                              amount: maxSpend.toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/icons/pencil.png',
                              scale: 4,
                            ),
                            Text(
                              'Edit',
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      ),
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
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            Text(
                              '${sc!.docs[0]['name']}',
                              style: GoogleFonts.openSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  }),
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
                      size: 18,
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
                    gender == 'Male'
                        ? Icon(
                            Icons.male,
                            color: Colors.white,
                            size: 16,
                          )
                        : Icon(
                            Icons.female,
                            color: Colors.white,
                            size: 16,
                          ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      gender.toString(),
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 23.0,
                  right: 15,
                ),
                child: Row(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .where('id',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final sc = snapshot.data;
                            return Row(
                              children: [
                                Image.asset(
                                  'assets/icons/pin.png',
                                  scale: 4.5,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${sc!.docs[0]['age']} Years Old',
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ],
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                    SizedBox(
                      width: 95,
                    ),

                    Text(
                      '\$ ${maxSpend}',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 23.0,
                  right: 15,
                ),
                child: Row(
                  children: [
                    haveCaar == 'Car'
                        ? Icon(
                      Icons.car_crash,
                      color: Colors.white,
                      size: 16,
                    )
                        : Icon(
                      Icons.car_rental_sharp,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      haveCaar.toString(),
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),                    SizedBox(
                      width: 95,
                    ),

                    // Text(
                    //   '\$ ${maxSpend}',
                    //   style: GoogleFonts.openSans(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
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
              Wrap(
                children: [
                  if (tags.isNotEmpty)
                    for (int i = 0; i < tags[0].tags!.length; i++)
                      ChoicePickChip(
                        title: '${tags[0].tags![i]}',
                      ),
                ],
              ),
            ],
          ),
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
