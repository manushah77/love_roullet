import 'package:auth_buttons/auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_roulette/Models/user_data.dart';
import 'package:love_roulette/Widegts/custom_btn.dart';
import 'package:love_roulette/screens/LoginScreen/login_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/continue_screen.dart';

import '../../Constant/color.dart';
import '../../Widegts/custom_text_field.dart';
import 'Auth_code/auth_code.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
   String? currentToken;

  UserData? userData;

  bool ispasswordvisible = true;
  bool ispasswordvisibleTwo = true;
  bool isUploaded = false;

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


    return Scaffold(
      backgroundColor: primaryColor,

      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),

              Container(
                width: screenWidtg / 1.15,
                height: screenHeight / 1.22,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/back.png',
                            scale: 1.5,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'SignUp',
                          style: GoogleFonts.openSans(
                            fontSize: 33,
                            fontWeight: FontWeight.w500,
                            color: whiteColor,
                          ),
                          textScaleFactor: 1.0,

                        ),
                        SizedBox(
                          width: 70,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),

                    //email

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Username',
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
                        validate: true,
                        controller: nameC,
                        hintText: 'Barbara Mahindra',
                      ),
                    ),
                    SizedBox(
                      height: 8,
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
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        controller: emailC,
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          var email = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (value == null || value == '') {
                            return 'Enter Your Email';
                          } else if (email.hasMatch(value)) {
                            return null;
                          } else
                            return "Wrong Email Adress";
                        },

                        decoration: InputDecoration(
                          suffixIconColor: whiteColor,
                          contentPadding: EdgeInsets.only(
                              top: 10, left: 15, right: 13, bottom: 10),
                          border: InputBorder.none,
                          hintText: 'barab@gmail.com',
                          hintStyle: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white38,
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 8,
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
                      height: 8,
                    ),

                    //confirm password


                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Confirm Password',
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
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        controller: confirmPasswordC,

                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordC.text) {
                            // ScaffoldMessenger.of(context)
                            //     .showSnackBar(SnackBar(
                            //   behavior: SnackBarBehavior.floating,
                            //   backgroundColor: Colors.white,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(7),
                            //   ),
                            //   content: Text(
                            //     "Psasword Not Match",
                            //     style: TextStyle(
                            //         color: primaryColor, fontSize: 19),
                            //   ),
                            //   duration: Duration(seconds: 2),
                            // ));

                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: ispasswordvisibleTwo,
                        decoration: InputDecoration(

                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                ispasswordvisibleTwo =
                                    !ispasswordvisibleTwo;
                              });
                            },
                            icon: Icon(
                              size: 20,
                              ispasswordvisibleTwo
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: whiteColor,
                            ),
                          ),
                          suffixIconColor: whiteColor,
                          contentPadding: EdgeInsets.only(
                              top: 10, left: 15, right: 13, bottom: 10),
                          border: InputBorder.none,
                          hintText: '******',
                          hintStyle: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white38,
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    isUploaded
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : CustomButton(
                            ontap: () {
                              if (formKey.currentState!.validate()) {
                                signup();
                                throw FormatException('Signup with out credentials');

                              }
                            },
                            txt: 'Continue',
                          ),
                  ],
                ),
              ),

              //

              SizedBox(
                height: 36,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You already have an account?',
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
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      ' Login',
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
    );
  }

  Future signup() async {
    try {
      setState(() {
        isUploaded = true;
      });
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailC.text, password: passwordC.text);
      User? user = credential.user;
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      if (user != null) {
        final doc =
            await FirebaseFirestore.instance.collection('user').doc(user.uid);
        userData = UserData(
          id: user.uid,
          name: nameC.text.toString().trim(),
          email: emailC.text.toString().trim(),
          imageOne: '',
          imageTwo: '',
          height: '',
          tags: [],
          weight:0,

          dataComplete:'notComplete',

          gender: '',
          age: '0',
          haveCar: '',
          minimumSpend: 0.0,
          maximumSpend: 0.0,
          flower: 5,
          latituelocation: 0,
          longitudelocation: 0,
          createdAt: time,
          isOnline: false,
          pushToken: currentToken,
          lastActive: time,
          timestamp : Timestamp.fromDate(DateTime.now()),
        );
        await doc.set(userData!.toMap()).then((value) {
          setState(() {
            isUploaded = false;
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
        isUploaded = false;
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
