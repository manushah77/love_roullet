import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love_roulette/Constant/color.dart';
import 'package:love_roulette/screens/LoginScreen/login_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/dob_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/selected_tags_screen.dart';
import 'package:love_roulette/screens/SignUpScreen/signup_screen.dart';

import '../../Models/user_data.dart';
import '../../Widegts/custom_btn.dart';
import 'continue_screen.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen>
    with WidgetsBindingObserver {
  String dropdownValue = 'Male';
  String dropdownValueTwo = 'Car';

  String? img;
  String? imgtwo;

  TextEditingController minC = TextEditingController();
  TextEditingController maxC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  UserData? userData;

  getData() async {
    // if (user != null) {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          userData =
              UserData.fromMap(res.docs.first.data() as Map<String, dynamic>);
          img = userData!.imageOne as String?;
          imgtwo = userData!.imageTwo;
        }
      });
    // }
  }

  File? _imageOne;
  File? _imageTwo;
  bool isUploaded = false;

//  for 1 image
  final pickerOne = ImagePicker();

  Future pickImageOne() async {
    var pickImage = await pickerOne.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickImage != null) {
        _imageOne = File(pickImage.path);
      } else {
        print('no image selected');
      }
    });
  }

  Future<String> uploadFileOne(File _imageOne) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child("image").child("post_$postId.png");
    await ref.putFile(_imageOne).then((value) {
      setState(() {
        isUploaded = true;
      });
    });
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

//for 2 image
  final pickerTwo = ImagePicker();

  Future pickImageTwo() async {
    var pickImage = await pickerTwo.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickImage != null) {
        _imageTwo = File(pickImage.path);
      } else {
        print('no image selected');
      }
    });
  }

  Future<String> uploadFileTwo(File _imageTwo) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child("image").child("post_$postId.png");
    await ref.putFile(_imageTwo).then((value) {
      setState(() {
        isUploaded = true;
      });
    });
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirebase() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
  }

  AppLifecycleState? _previousAppState;
  bool _isPreviousStateKilled = false;

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;

    Future signOut() async {
      await FirebaseAuth.instance.signOut();
      await DefaultCacheManager().emptyCache();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        // if (_isPreviousStateKilled) {
                        //   _exitApp();
                        // } else {
                        //   Navigator.of(context).pop();
                        // }

                        final NavigatorState navigator = Navigator.of(context);

                        // Check if the previous screen is killed
                        if (navigator.canPop()) {
                          navigator.pop();
                        } else {
                          // No previous screen, exit the app
                          // exit(0);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                          signOut();
                        }

                        return null;
                      },
                      child: Image.asset(
                        'assets/images/back.png',
                        scale: 1.5,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Step 2 of 3',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Add your photos',
                        style: GoogleFonts.openSans(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Add ableist 2 photos to get more attentions',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _showBottomSheet();
                      },
                      child: _imageOne != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.file(
                                _imageOne!,
                                fit: BoxFit.cover,
                                height: screenHeight / 5,
                                width: screenWidtg / 2.4,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                height: screenHeight / 5,
                                width: screenWidtg / 2.4,
                                color: Colors.grey.withOpacity(0.2),
                                child: Image.asset(
                                  'assets/icons/add.png',
                                  scale: 4,
                                ),
                              ),
                            ),
                    ),
                    InkWell(
                      onTap: () {
                        _showBottomSheetTwo();
                      },
                      child: _imageTwo != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.file(
                                _imageTwo!,
                                fit: BoxFit.cover,
                                height: screenHeight / 5,
                                width: screenWidtg / 2.4,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                height: screenHeight / 5,
                                width: screenWidtg / 2.4,
                                color: Colors.grey.withOpacity(0.2),
                                child: Image.asset(
                                  'assets/icons/add.png',
                                  scale: 4,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0),
                      child: Text(
                        'Gender',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: whiteColor.withOpacity(0.6),
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0, right: 8),
                //   child: Container(
                //     width: 330.w,
                //     height: 60.h,
                //     decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(0.3),
                //       borderRadius: BorderRadius.circular(30.0),
                //     ),
                //     child: DropdownButtonHideUnderline(
                //       child: Padding(
                //         padding: EdgeInsets.only(right: 20.0, left: 20),
                //         child: DropdownButton<String>(
                //           value: dropdownValue,
                //           iconSize: 24,
                //           icon: Icon(
                //             Icons.keyboard_arrow_down_rounded,
                //             color: Colors.white,
                //           ),
                //           style: TextStyle(color: whiteColor, fontSize: 17),
                //           onChanged: (String? newValue) {
                //             setState(() {
                //               dropdownValue = newValue!;
                //             });
                //           },
                //           items: <String>[
                //             'Male',
                //             'Female',
                //             'Other',
                //           ].map<DropdownMenuItem<String>>((values) {
                //             return DropdownMenuItem<String>(
                //               value: values,
                //               child: Text(
                //                 values,
                //                 style: TextStyle(color: Colors.grey),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    width: screenWidtg / 1.12,
                    height: 50,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: <String>[
                          'Male',
                          'Female',
                          'Other',
                        ]
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: dropdownValue,
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value as String;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                          iconSize: 28,
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.shade900,
                          ),
                          elevation: 8,
                          scrollbarTheme: ScrollbarThemeData(
                            radius: Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                ),

                //1st text field

                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0),
                      child: Text(
                        'Do you have Car / RideShare',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: whiteColor.withOpacity(0.6),
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0, right: 8),
                //   child: Container(
                //     width: 330.w,
                //     height: 60.h,
                //     decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(0.3),
                //       borderRadius: BorderRadius.circular(30.0),
                //     ),
                //     child: DropdownButtonHideUnderline(
                //       child: Padding(
                //         padding: EdgeInsets.only(right: 20.0, left: 20),
                //         child: DropdownButton<String>(
                //           value: dropdownValue,
                //           iconSize: 24,
                //           icon: Icon(
                //             Icons.keyboard_arrow_down_rounded,
                //             color: Colors.white,
                //           ),
                //           style: TextStyle(color: whiteColor, fontSize: 17),
                //           onChanged: (String? newValue) {
                //             setState(() {
                //               dropdownValue = newValue!;
                //             });
                //           },
                //           items: <String>[
                //             'Male',
                //             'Female',
                //             'Other',
                //           ].map<DropdownMenuItem<String>>((values) {
                //             return DropdownMenuItem<String>(
                //               value: values,
                //               child: Text(
                //                 values,
                //                 style: TextStyle(color: Colors.grey),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    width: screenWidtg / 1.12,
                    height: 50,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: <String>[
                          'Car',
                          'RideShare',
                        ]
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: dropdownValueTwo,
                        onChanged: (value) {
                          setState(() {
                            dropdownValueTwo = value as String;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                          iconSize: 28,
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.shade900,
                          ),
                          elevation: 8,
                          scrollbarTheme: ScrollbarThemeData(
                            radius: Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0, right: 10),
                      child: Text(
                        'How Minimum you can you spend on a date',
                        style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: whiteColor.withOpacity(0.6),
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
                  width: screenWidtg / 1.12,
                  height: 70,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value == '' || value == null) {
                        return 'Enter Minimum Expense';
                      }
                    },
                    controller: minC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: Text(
                        '\$ ',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      suffixIconColor: whiteColor,
                      contentPadding: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 5),
                      border: InputBorder.none,
                      hintText: 'Free',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      filled: true,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Colors.grey.withOpacity(0.2),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                //2nd text field

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0, right: 10),
                      child: Text(
                        'How Maximum you can you spend on a date',
                        style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: whiteColor.withOpacity(0.6),
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
                  width: screenWidtg / 1.12,
                  height: 70,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value == '' || value == null) {
                        return 'Enter Maxium Expense';
                      }
                    },
                    controller: maxC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: Text(
                        '\$ ',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      suffixIconColor: whiteColor,
                      contentPadding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      border: InputBorder.none,
                      hintText: '100',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      filled: true,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fillColor: Colors.grey.withOpacity(0.2),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isUploaded
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : CustomButton(
                        txt: 'Continue',
                        ontap: () async {
                          try {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isUploaded = true;
                              });
                              String urlOne = await uploadFileOne(_imageOne!);
                              String urlTwo = await uploadFileTwo(_imageTwo!);

                              User? user = FirebaseAuth.instance.currentUser;
                              final time = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              if (user != null) {
                                final documentReference =
                                    await FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(user.uid);
                                userData = UserData(
                                  name: userData!.name,
                                  email: userData!.email,
                                  id: user.uid,
                                  age: userData!.age,
                                  height: userData!.height,
                                  weight: userData!.weight,
                                  haveCar: dropdownValueTwo,
                                  imageOne: urlOne,
                                  dataComplete:'notComplete',
                                  pushToken: userData!.pushToken,
                                  imageTwo: urlTwo,
                                  createdAt: time,
                                  flower: 5,
                                  isOnline: false,
                                  lastActive: time,
                                  // time: DateTime.timestamp(),
                                  timestamp: Timestamp.fromDate(DateTime.now()),

                                  maximumSpend:
                                      double.parse(maxC.text.toString()),
                                  minimumSpend:
                                      double.parse(minC.text.toString()),
                                  gender: dropdownValue,
                                  latituelocation:
                                      userData!.latituelocation!.toDouble(),
                                  longitudelocation:
                                      userData!.longitudelocation!.toDouble(),
                                  tags: [],
                                );
                                await documentReference.id;
                                await documentReference
                                    .update(userData!.toMap())
                                    .then(
                                  (value) {
                                    setState(() {
                                      isUploaded = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectedTagScreen()), // Replace "HomeScreen()" with your app's home screen.
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        content: Text(
                                          "Photos Section Added SuccessFully",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19),
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              }
                              throw FormatException('Errors');
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isUploaded = false;
                            });
                            return ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              content: Text(
                                "${e.message}",
                                style: TextStyle(
                                    color: primaryColor, fontSize: 19),
                              ),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //for picking profile pick
    void _showBottomSheet() {
      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          context: context,
          builder: (_) {
            return ListView(
              padding: EdgeInsets.only(top: 15),
              shrinkWrap: true,
              children: [
                Text(
                  'Upload Profile\n photos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(110, 110),
                        elevation: 1,
                        shape: CircleBorder(),
                      ),
                      onPressed: () async {
                        var pickImage =
                            await pickerOne.getImage(source: ImageSource.gallery);

                        setState(() {
                          if (pickImage != null) {
                            _imageOne = File(pickImage.path);
                          } else {
                            print('no image selected');
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/gal.png'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(110, 110),
                        shape: CircleBorder(),
                        elevation: 1,
                      ),
                      onPressed: () async {
                        var pickImage =
                            await pickerOne.getImage(source: ImageSource.camera);

                        setState(() {
                          if (pickImage != null) {
                            _imageOne = File(pickImage.path);
                          } else {
                            print('no image selected');
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/camera.png',
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          });
    }

  void _showBottomSheetTwo() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (_) {
          return ListView(
            padding: EdgeInsets.only(top: 15),
            shrinkWrap: true,
            children: [
              Text(
                'Upload Profile\n photos',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      fixedSize: Size(110, 110),
                      shape: CircleBorder(),
                    ),
                    onPressed: () async {
                      var pickImage =
                          await pickerOne.getImage(source: ImageSource.gallery);

                      setState(() {
                        if (pickImage != null) {
                          _imageTwo = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/gal.png'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      fixedSize: Size(110, 110),
                      shape: CircleBorder(),
                    ),
                    onPressed: () async {
                      var pickImage =
                          await pickerOne.getImage(source: ImageSource.camera);

                      setState(() {
                        if (pickImage != null) {
                          _imageTwo = File(pickImage.path);
                        } else {
                          print('no image selected');
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/camera.png',
                      color: Colors.grey.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }
}
