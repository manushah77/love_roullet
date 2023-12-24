import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_roulette/Constant/color.dart';

import '../../Widegts/custom_btn.dart';
import '../../Widegts/custom_text_field.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController emailC = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
              ),
              Center(
                child: Container(
                  width: 320,
                  height: 330,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Forgot Password?',
                        style: GoogleFonts.openSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
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

                      //password



                      SizedBox(
                        height: 45,
                      ),
                    CustomButton(
                        txt: 'Done',
                        ontap: () {
                          if (formKey.currentState!.validate()) {
                            resetPassword().then((value) {
                              Navigator.pop(context);
                            });
                          }
                        },
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
  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailC.text.trim());
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        content: Text(
          "Check your Email Spam Folder",
          style: TextStyle(color: primaryColor, fontSize: 19),
        ),
        duration: Duration(seconds: 2),
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
