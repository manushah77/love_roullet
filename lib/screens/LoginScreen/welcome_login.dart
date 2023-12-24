import 'dart:convert';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:love_roulette/Constant/color.dart';
import 'package:love_roulette/Widegts/notification_class.dart';
import 'package:love_roulette/screens/LoginScreen/login_screen.dart';

import '../../Widegts/alert_dialog_widget.dart';
import '../BottomNavigationBar/bottom_bar.dart';
import '../SignUpScreen/Auth_code/auth_code.dart';
import '../SignUpScreen/continue_screen.dart';
import 'package:http/http.dart' as http;

class WelcomeLogin extends StatefulWidget {
  const WelcomeLogin({Key? key}) : super(key: key);

  @override
  State<WelcomeLogin> createState() => _WelcomeLoginState();
}

class _WelcomeLoginState extends State<WelcomeLogin> {
  PageController pageController = PageController();
  int pageIndex = 0;

  NotificationServices notificationService = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService.requestNotificationPermission();
    // services.RefreshgetDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMsg(context);
    notificationService.getDeviceToken().then((value) {
      print('device token is : ');
      print(value);
    });
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Stack(
        children: [
          PageView.builder(
            itemCount: demoData.length,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                pageIndex = index;
              });
            },
            itemBuilder: (context, index) => OnBoardWidget(
              title: demoData[index].title,
              img: demoData[index].img,
              txt1: demoData[index].txt1,
              txt2: demoData[index].txt2,
              ontap: () {
                // pageController.nextPage(
                //   duration: Duration(milliseconds: 300),
                //   curve: Curves.ease,
                // );
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => LoginScreen(),
                //   ),
                // );
              },
              btnTxt: demoData[index].btnTxt,
              txt3: demoData[index].txt3,
              txt4: demoData[index].txt4,
              txt5: demoData[index].txt5,
              txt6: demoData[index].txt6,
            ),
          ),
          Positioned(
            top: 525,
            left: 120,
            child: Row(
              children: [
               ...List.generate(demoData.length, (index) => Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: DotWidget(isActive: index ==  pageIndex,),
               ))
              ],
            ),
          ),

        ],
      )),
    );
  }

  //goole auth

  Future<String> _googleSignIn() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          // ignore: unused_local_variable
          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        content: Text(
          "Check Connection",
          style: TextStyle(color: primaryColor, fontSize: 19),
        ),
        duration: Duration(seconds: 2),
      ));
    }
    return 'ok';
  }

//google auth button code

// handlebuttonClick() {
//   AlertDialogWidget.showProgresbar(context);
//   _googleSignIn().then((user) async {
//     Navigator.pop(context);
//     if (user != null) {
//       if ((await AuthWork.userExists())) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => BottomBar(
//                     selectedIndex: 0,
//                   )),
//         );
//       } else {
//         await AuthWork.createUserGmail().then((value) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ContinueScreen(),
//             ),
//           );
//         });
//       }
//     }
//   });
// }
}

class DotWidget extends StatelessWidget {
   DotWidget({
    this.isActive = false,
  });
  final bool isActive;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width:  isActive ? 60 : 30,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.withOpacity(0.8) : Colors.grey.withOpacity(0.3) ,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class OnBoard {
  final String img, title, txt1, txt2, txt3, txt4, txt5, txt6, btnTxt;

  OnBoard(
      {required this.title,
      required this.img,
      required this.txt1,
      required this.txt2,
      required this.txt3,
      required this.txt4,
      required this.txt5,
      required this.txt6,
      required this.btnTxt});
}

final List<OnBoard> demoData = [
  OnBoard(
      title: 'Love Roulette',
      img: 'assets/images/welcome_login.png',
      txt1: 'Take a chance and go on a date.',
      txt2: 'Meet quality singles looking for\n a relationship.',
      btnTxt: 'Contine',
      txt3: 'By signing up for Delight, you agree to our',
      txt4: ' Terms Of Services',
      txt5: 'Learn how we process your data in our',
      txt6: 'Privacy Policy.'),
  OnBoard(
      title: 'Love Roulette',
      img: 'assets/images/welcome_login 2.png',
      txt1: 'Take a chance and go on a date.',
      txt2: 'Rotate the roulette to find the love\n of your life.',
      btnTxt: 'Get Started',
      txt3: 'By signing up for Delight, you agree to our',
      txt4: ' Terms Of Services',
      txt5: 'Learn how we process your data in our',
      txt6: 'Privacy Policy.')
];

class OnBoardWidget extends StatefulWidget {
  OnBoardWidget(
      {required this.title,
      required this.img,
      required this.txt1,
      required this.txt2,
      required this.txt3,
      required this.txt4,
      required this.txt5,
      required this.txt6,
      required this.ontap,
      required this.btnTxt});

  final String img, title, txt1, txt2, txt3, txt4, txt5, txt6, btnTxt;
  final Function ontap;

  @override
  State<OnBoardWidget> createState() => _OnBoardWidgetState();
}

class _OnBoardWidgetState extends State<OnBoardWidget> {
  NotificationServices notificationServices = NotificationServices();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    // services.RefreshgetDeviceToken();
    notificationServices.firebaseInit(context);
    notificationServices.foregroundMessage();

    notificationServices.setupInteractMsg(context);
    notificationServices.getDeviceToken().then((value) {
      print('device token is : ');
      print(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.img),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 12,
                ),
                child: Text(
                  widget.title,
                  style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  textScaleFactor: 1.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 12,
                ),
                child: Text(
                  // 'Take a chance and go on a date.',
                  widget.txt1,
                  style: GoogleFonts.openSans(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight / 1.78,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10),
            child: Row(
              children: [
                Text(
                  widget.txt2,
                  // 'Meet quality singles looking for\n a relationship.',
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white60,
                  ),
                  textScaleFactor: 1.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: () {


              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
              notificationServices.getDeviceToken().then((value) async{
                var data = {
                  'to': value.toString(),
                  'priority' : 'high',
                  'notification' : {
                    'title' :  'Welcome',
                    'body' : 'Love Roulette Dating App',
                    "android_channel_id": "dating app"
                  }
                };
                await http.post(Uri.parse('http://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data), headers: {
                      'Content-Type' : 'application/json; charset=UTF-8',
                      'Authorization' : 'key=AAAA8E2XqVo:APA91bHfbiTR4D8apLqiatJgivMpJp7hzPOvmGB7zjhtjeILSfWYNf2MVXuIR09F3xgloOCUZioKKkbs4dmkQJglI4uGcgGeMYrGAKDv19BB1uXPMIHKjccif-ROofGw4Z_vSQs5Vx1c',
                    });
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 20),
              child: Container(
                width: screenWidtg / 1.12,
                height: screenHeight / 12.5,
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
                  width: screenWidtg / 1.15,
                  height: screenHeight / 14.2,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: GoogleFonts.openSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Text(
                  widget.txt3,
                  style: GoogleFonts.openSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: Colors.white54,
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
              Text(
                widget.txt4,
                style: GoogleFonts.openSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Text(
                  widget.txt5,
                  style: GoogleFonts.openSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: Colors.white54,
                  ),
                  textScaleFactor: 1.0,
                ),
              ),
              Text(
                widget.txt6,
                style: GoogleFonts.openSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textScaleFactor: 1.0,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
