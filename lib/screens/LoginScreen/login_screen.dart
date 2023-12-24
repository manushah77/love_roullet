import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:love_roulette/Widegts/custom_text_field.dart';
import 'package:love_roulette/screens/BottomNavigationBar/bottom_bar.dart';
import 'package:love_roulette/screens/LoginScreen/forgot_password_screen.dart';
import 'package:love_roulette/screens/LoginScreen/welcome_login.dart';
import 'package:love_roulette/screens/SignUpScreen/continue_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/signup_screen.dart';

import '../../Constant/color.dart';
import '../../Models/user_data.dart';
import '../../Widegts/alert_dialog_widget.dart';
import '../../Widegts/custom_btn.dart';
import '../SignUpScreen/Auth_code/auth_code.dart';
import '../SignUpScreen/add_photos_screen.dart';
import '../SignUpScreen/selected_tags_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool ispasswordvisible = true;

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? currentToken;

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
      }
      // else {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => LoginScreen(),
      //       ),
      //     );
      //   });
      // }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
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
    // TODO: implement initState
    super.initState();
    _messaging.getToken().then((value) {
      print(value);
      if (mounted)
        setState(() {
          currentToken = value!;
        });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => exit(0),

      child: Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                ),
                Image.asset(
                  'assets/images/login_logo.png',
                  scale: 1.4,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Love Roulette',
                  style: GoogleFonts.openSans(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
                  textScaleFactor: 1.0,
                ),
                Text(
                  'Fill the below information to log in.',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: whiteColor,
                  ),
                  textScaleFactor: 1.0,
                ),
                SizedBox(
                  height: 20,
                ),

                //login Container

                Container(
                  width: screenWidtg / 1.15,
                  height: screenHeight / 2.08,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Login Account',
                        style: GoogleFonts.openSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //email

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              'Email',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
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
                        width: screenWidtg / 1.25,
                        height: 60,
                        child: CustomTextField(
                          controller: emailC,
                          hintText: 'barbara.cooper@mail.com',
                          validate: true,
                        ),
                      ),

                      //password

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              'Password',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
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
                        width: screenWidtg / 1.25,
                        height: 60,
                        child: CustomTextField(
                          hintText: '*********',
                          controller: passwordC,
                          validate: true,
                          obsecureText: ispasswordvisible,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                ispasswordvisible = !ispasswordvisible;
                              });
                            },
                            icon: Icon(
                              size: 20,
                              ispasswordvisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password ?',
                                style: GoogleFonts.openSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      isLoading == true
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : CustomButton(
                              txt: 'Login',
                              ontap: () {
                                if (formKey.currentState!.validate()) {
                                  login().then((value) {
                                    getData();
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(SnackBar(
                                    //   behavior: SnackBarBehavior.floating,
                                    //   backgroundColor: Colors.white,
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(7),
                                    //   ),
                                    //   content: Text(
                                    //     "Login SuccessFully",
                                    //     style: TextStyle(
                                    //         color: primaryColor, fontSize: 19),
                                    //   ),
                                    //   duration: Duration(seconds: 2),
                                    // ));
                                  });

                                  throw FormatException(
                                      'Login with out credentials');
                                }
                              },
                            ),
                    ],
                  ),
                ),

                //

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: 75,
                      color: Colors.white30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'OR',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 2,
                      width: 75,
                      color: Colors.white30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 316,
                  height: 56,
                  child: GoogleAuthButton(
                    text: 'Continue with Google',
                    onPressed: () {
                      handlebuttonClick();
                    },
                    style: AuthButtonStyle(
                        borderRadius: 10,
                        iconType: AuthIconType.secondary,
                        iconSize: 22,
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white54,
                      ),
                      textScaleFactor: 1.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        ' Sign Up',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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

  handlebuttonClick() {
    AlertDialogWidget.showProgresbar(context);
    _googleSignIn().then((user) async {
      Navigator.pop(context);
      if ((await AuthWork.userExists())) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBar(selectedIndex: 0,),
          ),
        );
      } else {
        await googleSignup();
      }
    });
  }

  //login function
  Future login() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailC.text, password: passwordC.text);
      setState(() {
        isLoading = false;
      });

      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        content: Text(
          "${e.message}",
          style: TextStyle(color: primaryColor, fontSize: 19),
        ),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
  }

  Future googleSignup() async {
    try {
      setState(() {
        isLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser!;
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      if (user != null) {
        final doc =
        await FirebaseFirestore.instance.collection('user').doc(user.uid);
        userData = UserData(
          id: user.uid,
          name: '${user.displayName}',
          email: '${user.email}',
          imageOne: '',
          imageTwo: '',
          height: '',
          gender: '',
          age: '0',
          weight: 0.0,
          minimumSpend: 0.0,
          maximumSpend: 0.0,
          latituelocation: 0.0,
          longitudelocation: 0.0,
          createdAt: time,
          dataComplete:'notComplete',
          isOnline: false,
          lastActive: time,
          pushToken: currentToken,
        );
        await doc.set(userData!.toMap()).then((value) {
    setState(() {
    isLoading = false;
    });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ContinueScreen()), // Replace "HomeScreen()" with your app's home screen.
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          content: Text(
            "User Sign Up SuccessFully",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          duration: Duration(seconds: 2),
        ));
      }
    } on FirebaseAuthException catch (e) {
    setState(() {
    isLoading = false;
    });
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        content: Text(
          "${e.message}",
          style: TextStyle(color: primaryColor, fontSize: 19),
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }



}
