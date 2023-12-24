import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:love_roulette/screens/BottomNavigationBar/bottom_bar.dart';
import 'package:love_roulette/screens/LoginScreen/login_screen.dart';
import 'package:love_roulette/screens/LoginScreen/welcome_login.dart';
import 'package:love_roulette/screens/SignUpScreen/add_photos_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/continue_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/selected_tags_screen.dart';

import '../../Constant/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserData userData = UserData();

  Future<void> getData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot docSnapshot = await firestore
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        userData = UserData.fromMap(data);
        checkUser(userData);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeLogin(),
            ),
          );
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeLogin(),
          ),
        );
      });
    }
  }

  checkUser(UserData user) {
    print(user.age);
    if (user.age == '0') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ContinueScreen(),
        ),
      );
    } else if (user.gender == '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddPhotoScreen(),
        ),
      );
    } else if (user.tags!.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedTagScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBar(selectedIndex: 0,),
        ),
      );
    }
  }

  @override
  void initState() {
    Timer(
      Duration(seconds: 6),
      () => getData(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Lottie.asset(
                  'assets/heart.json',
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/gg.png',
                        scale: 5,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/love.png',
                        scale: 1.7,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
