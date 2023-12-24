import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:love_roulette/Models/date_model.dart';
import 'package:love_roulette/screens/BottomNavigationBar/BottomBarScreens/profile/selected_profile.dart';
import 'package:badges/badges.dart' as badge;
import 'package:love_roulette/screens/HomeScreen/matching_screen.dart';
import 'package:love_roulette/screens/HomeScreen/notification_screen.dart';
import 'package:http/http.dart' as http;
import '../../Constant/color.dart';
import 'dart:math' as math;

import '../../Models/user_data.dart';
import '../BottomNavigationBar/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  StreamController<int> selected = StreamController<int>();

  String os = Platform.operatingSystem;

  List<UserData> userdata = [];
  UserData? userdat;

  final user = FirebaseAuth.instance.currentUser;
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

  //get user from firebase
  int? flower;

  getUser() async {
    if (user != null) {
      QuerySnapshot res = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isNotEqualTo: user!.uid)
          .where('dataComplete', isEqualTo : 'Complete')
          .get();
      if (res.docs.isNotEmpty) {
        setState(() {
          userdata = res.docs
              .map((e) => UserData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
        });
      }
    }

    if (user != null) {
      QuerySnapshot rest = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: user!.uid)
          .get();
      if (rest.docs.isNotEmpty) {
        setState(() {
          userdat =
              UserData.fromMap(rest.docs.first.data() as Map<String, dynamic>);
          flower = userdat!.flower;
        });
      }
    }
  }

  //get notificatiion for date
  bool isFirstTime = true;


  List<DatedData> dateddata = [];
  bool? badgee;
  bool? badgeeTwo;

  bool show = false;

  getNotificationBage() async {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('Date')
        .where('DatedMemberId', isEqualTo: user!.uid)
        .get();
    if (res.docs.isNotEmpty) {
      setState(() {
        dateddata = res.docs
            .map((e) => DatedData.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        badgee = dateddata[0].Accepted;
        badgeeTwo = dateddata[0].Rejected;
      });
      // print(badgee);
      // print('user .......');

      if(dateddata.isNotEmpty) {
        if(badgee == false && badgeeTwo == false) {
          showBadge(true);
          show = true;
        }
        else {
          showBadge(false);
          show = false;
        }
      }
    }
  }




  showBadge (bool show) {
   return badge.Badge(
     position: badge.BadgePosition.topEnd(top: 1, end: -1),
     showBadge: show,
      badgeContent: Container(
        width: 2,
        height: 2,
      ),
      child: Image.asset(
        'assets/images/bell.png',
        scale: 2,
      ),
    );
  }

  // bool isBadge = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    getConnectivity();
    getUser();
    generateItemRadian();
    currentImagePath = getRandomImagePath();
    getNotificationBage();


    //animation controller
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3600),
    );
    //the tween

    Tween<double> tween = Tween<double>(begin: 0, end: 1);

    //curve

    CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);

    //animation
    animation = tween.animate(curve);

    //rebuild screen as animation contines

    controller.addListener(
      () {
        //only when animation compelete
        if (controller.isCompleted) {
          setState(() {
            recordStats();
            //update status
            spinng = false;
          });
        }
      },
    );
  }


  @override
  void dispose() {
    controller.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstTime) {
      setState(() {
        isFirstTime = false;
      });
    }
  }

  int selectedUserIndex = 0;
  bool isSpinning = false;
  bool hasSpin = false;

  // startSpin() {
  //   // Simulate spinning delay
  //   setState(() {
  //     isSpinning = true;
  //   });
  //
  //   Future.delayed(Duration(seconds: 2), () {
  //     setState(() {
  //       selectedUserIndex = calculateSelectedUserIndex();
  //       isSpinning = false;
  //     });
  //   });
  // }
  startSpin() async {
    if (flower! <= 0) {
      // Show purchase spin dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Purchase Spins"),
          content: Text("Would you like to purchase additional spins?"),
          actions: [
            TextButton(
              onPressed: () {
                showdialog();
                // Implement purchase functionality
                // Navigator.pop(context); // Close dialog
              },
              child: Text("Purchase"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      );
      return;
    }

    if (isSpinning) {
      return; // Prevent starting a new spin while already spinning
    }

    if (flower! >= 0) {
      // Continue with spinning logic

      // Simulate spinning delay
      setState(() {
        isSpinning = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          selectedUserIndex = calculateSelectedUserIndex();
          isSpinning = false;
          flower! - 1; // Increment the spin counter
        });
      });
    }
  }

  int calculateSelectedUserIndex() {
    // Calculate the selected user index based on the wheel's position or index
    // This can be done using the rotation angle or any other relevant mechanism
    // In this example, a random index is selected
    return userdata.length > 0
        ? DateTime.now().microsecondsSinceEpoch % userdata.length
        : 0;
  }

  void matchUserForDate() async {
    await Future.delayed(Duration(seconds: 4)); // Adding a delay of 2 seconds

    UserData selectedUser = userdata[selectedUserIndex];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 295,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 10,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'CONGRATS YOU,VE BEEN \nSELECTED FOR A DATE',
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 88,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffFFE2A9),
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/logo.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${selectedUser.name}',
                            style: GoogleFonts.openSans(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textScaleFactor: 1.0,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SelectedUserProfileScreen(
                                    name: '${selectedUser.name}',
                                    age: int.parse(selectedUser.age.toString()),
                                    gender: '${selectedUser.gender}',
                                    img: '${selectedUser.imageOne}',
                                    imgTwo: '${selectedUser.imageTwo}',
                                    latitue: double.parse(selectedUser
                                        .latituelocation
                                        .toString()),
                                    longitute: double.parse(selectedUser
                                        .longitudelocation
                                        .toString()),
                                    id: '${selectedUser.id}',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 25,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xffBEBFC4),
                              ),
                              child: Center(
                                child: Text(
                                  'View Profile',
                                  style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchingScreen(
                          name: '${selectedUser.name}',
                          img: '${selectedUser.imageOne}',
                          latLocation: double.parse(
                              selectedUser.latituelocation.toString()),
                          longLocation: double.parse(
                              selectedUser.longitudelocation.toString()),
                          id: '${selectedUser.id}',
                          age: '${selectedUser.age}',
                          gender: '${selectedUser.gender}',
                          token: '${selectedUser.pushToken}',
                        ),
                      ),
                    );
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: Colors.white,
                    radius: Radius.circular(30),
                    child: Container(
                      height: 45,
                      width: 190,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Okay',
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
                ),
              ],
            ),
          );
        });
  }

  List<double> items = [
    1,
    2,
    4,
  ];

  int rendomSector = -1;

  int spin = 1;

  List<double> itemRadian = [];
  double angle = 0;
  double earnedvalue = 0;
  bool spinng = false;

  math.Random random = math.Random();

  late AnimationController controller;
  late Animation<double> animation;

  List<String> imagePaths = [
    'assets/images/whel1.png',
    'assets/images/whel2.png',
    // 'assets/images/wheel3.png',
    // 'assets/images/wheel4.png',
    // 'assets/images/wheel5.png',
    // 'assets/images/wheel6.png',
    // Add more image paths as needed
  ];

  // int currentIndex = 0; // Index to track the current image
  Random randoms = Random();
  String? currentImagePath; // Variable to store the current image path
  // Random random = Random(); // Random object to generate random indices

  String getRandomImagePath() {
    int randomIndex = randoms.nextInt(imagePaths.length);
    return imagePaths[randomIndex];
  }

  void updateRandomImage() {
    setState(() {
      currentImagePath = getRandomImagePath();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => exit(0),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Love Roulette 🔥',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: whiteColor,
            ),
            textScaleFactor: 1.0,
          ),
          actions: [
            Container(
              height: 55,
              width: 40,
              decoration: BoxDecoration(
                color: Color(0xff000000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🌹',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  flower == '' || flower == null
                      ? Text(
                          '0',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        )
                      : Text(
                          '$flower',
                          style: TextStyle(
                            fontSize: 11,
                          ),
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                        ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(
                    ),
                  ),
                );
                show = false;
                showBadge(false);
              },

              child: showBadge(show),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/bdl.jpg'),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 20,
                    child: Text(
                      'Press on Heart to Spin and match\n your favorite person for a date',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: animation,
                    builder: ((context, child) {
                      return Transform.rotate(
                        angle: controller.value * angle,
                        child: Center(
                          child: Image.asset(
                            '${currentImagePath}',
                            // 'assets/images/whel1.png',
                            scale: 4,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                  Positioned.fill(
                    top: 10,
                    right: 10,
                    left: 10,
                    bottom: 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          isSpinning ? null : startSpin();

                          setState(() {
                            //if not spinning
                            if (flower! <= 0) {
                              spinng = false;
                              //update
                            } else if (!spinng) {
                              spinn();
                              // startSpin();
                              matchUserForDate();
                              spinng = true;
                              setState(() {
                                flower = flower! - 1;
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(user!.uid)
                                    .update({
                                  "flower": flower,
                                });
                              });
                            }
                            // currentIndex = randoms.nextInt(imagePaths.length);
                          });

                          // bottomshet();
                        },
                        child: Image.asset(
                          'assets/images/dil.png',
                          scale: 4.3,
                        ),
                      ),
                    ),
                  ),
                ],
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

  void generateItemRadian() {
    //radian for 1 sector

    double sectorRadian = 4 * math.pi / items.length;

    for (int i = 0; i < items.length; i++) {
      itemRadian.add((i + 1) * sectorRadian);
    }
  }

  void recordStats() {
    earnedvalue =
        items[items.length - (rendomSector + 1)]; //for currently earned
    spin = spin + 1;
  }

  spinn() {
    rendomSector = random.nextInt(items.length);
    double randomRadion = generateRandomToSpinTo();
    controller.reset();
    angle = randomRadion;
    controller.forward();
  }

  double generateRandomToSpinTo() {
    // return (Random().nextDouble() * pi * 14);
    return (6 * math.pi * items.length);
    // return (6 * math.pi * items.length) + itemRadian[rendomSector];
    // return  Random().nextDouble() * pi * 17;
  }

  //diaload purchase
  static const String iapId = 'android.test.purchased';

  showdialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isSelected = false;
        bool isSelected1 = false;
        bool isSelected2 = false;

        return StatefulBuilder(builder: (context, setStateSB) {
          return Dialog(
            insetPadding: EdgeInsets.only(left: 10, right: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 515,
              width: 310,
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0, top: 5),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    Image.asset(
                      'assets/images/hera.png',
                      scale: 1.1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Unlimited Access',
                        style: GoogleFonts.openSans(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Get Access to all our features',
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textScaleFactor: 1.0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/tik.png',
                          scale: 1.2,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Buy Flower to get more spin',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/tik.png',
                          scale: 1.2,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Other Cool features             ',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      endIndent: 30,
                      indent: 25,
                      color: Colors.black12,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Choose a Plan',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (isSelected == true) {
                              setStateSB(() {
                                isSelected = false;
                              });
                            } else {
                              setStateSB(() {
                                isSelected = true;
                                isSelected1 = false;
                                isSelected2 = false;
                              });
                            }
                            await makePayment();
                          },
                          child: Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 2,
                                color: isSelected == true
                                    ? Colors.orangeAccent
                                    : Colors.transparent,
                              ),
                              color: isSelected == true
                                  ? Colors.orangeAccent.withOpacity(0.2)
                                  : Colors.black12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '05',
                                  style: GoogleFonts.openSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  'Flower',
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  '\$ 4.99',
                                  style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (isSelected1 == true) {
                              setStateSB(() {
                                isSelected1 = false;
                              });
                            } else {
                              setStateSB(() {
                                isSelected = false;
                                isSelected1 = true;
                                isSelected2 = false;
                              });
                            }
                            await makePaymentTwo();
                          },
                          child: Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: isSelected1 == true
                                    ? Colors.orangeAccent
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: isSelected1 == true
                                  ? Colors.orangeAccent.withOpacity(0.2)
                                  : Colors.black12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '10',
                                  style: GoogleFonts.openSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  'Flower',
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  '\$ 6.99',
                                  style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (isSelected2 == true) {
                              setStateSB(() {
                                isSelected2 = false;
                              });
                            } else {
                              setStateSB(() {
                                isSelected = false;
                                isSelected1 = false;
                                isSelected2 = true;
                              });
                            }
                            await makePaymentThree();
                          },
                          child: Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: isSelected2 == true
                                    ? Colors.orangeAccent
                                    : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: isSelected2 == true
                                  ? Colors.orangeAccent.withOpacity(0.2)
                                  : Colors.black12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '20',
                                  style: GoogleFonts.openSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  'Flower',
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                                Text(
                                  '\$ 12.99',
                                  style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
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
                    // MaterialButton(
                    //   color: Colors.black,
                    //   height: 50,
                    //   minWidth: 250,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   onPressed: () async{
                    //     // Navigator.pop(context);
                    //     // _buyProduct();
                    //    await makePayment();
                    //   },
                    //   child: Text(
                    //     'Continue',
                    //     style: TextStyle(color: Colors.white),
                    //     textScaleFactor: 1.0,
                    //   ),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Map<String, dynamic>? paymentIntent;
  Map<String, dynamic>? paymentIntent1;
  Map<String, dynamic>? paymentIntent2;

  // 1st on click

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('499', 'USD');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "USD", currencyCode: "USD", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'JEUX',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
          "flower": 5,
        }).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBar(
                selectedIndex: 0,
              ),
            ),
          );
        });
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NQTzdLcq76fpBhMl515uKfa6sN9AZHEfkWP1UHn8OvYoSzomCgb5GHe1uOTakWC3uAi0Mg4o5cStaYgJNhYkCk000tH0eCxqr',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      paymentIntent = jsonDecode(response.body);
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //2nd on click

  Future<void> makePaymentTwo() async {
    try {
      paymentIntent = await createPaymentIntentTwo('699', 'USD');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "USD", currencyCode: "USD", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent1![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'JEUX',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheetTwo();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheetTwo() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
          "flower": 10,
        }).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBar(
                selectedIndex: 0,
              ),
            ),
          );
        });
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntentTwo(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NQTzdLcq76fpBhMl515uKfa6sN9AZHEfkWP1UHn8OvYoSzomCgb5GHe1uOTakWC3uAi0Mg4o5cStaYgJNhYkCk000tH0eCxqr',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      paymentIntent1 = jsonDecode(response.body);
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //3rd on click

  Future<void> makePaymentThree() async {
    try {
      paymentIntent = await createPaymentIntentThree('1299', 'USD');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "USD", currencyCode: "USD", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent2![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'JEUX',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheetThree();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheetThree() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
          "flower": 20,
        }).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBar(
                selectedIndex: 0,
              ),
            ),
          );
        });
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntentThree(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NQTzdLcq76fpBhMl515uKfa6sN9AZHEfkWP1UHn8OvYoSzomCgb5GHe1uOTakWC3uAi0Mg4o5cStaYgJNhYkCk000tH0eCxqr',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      paymentIntent2 = jsonDecode(response.body);
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
