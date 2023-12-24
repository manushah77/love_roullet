import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:love_roulette/screens/BottomNavigationBar/bottom_bar.dart';
import 'package:love_roulette/screens/SignUpScreen/add_photos_screen.dart';
import '../../Constant/color.dart';
import '../../Models/user_data.dart';
import '../../Widegts/custom_btn.dart';
import '../LoginScreen/login_screen.dart';

class SelectedTagScreen extends StatefulWidget {
  const SelectedTagScreen({Key? key}) : super(key: key);

  @override
  State<SelectedTagScreen> createState() => _SelectedTagScreenState();
}

class _SelectedTagScreenState extends State<SelectedTagScreen> with WidgetsBindingObserver {

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

        }
      });
    // }
  }

  List<String> selectedValues = [];
 bool isUploaded = false;


   AppLifecycleState? _previousAppState;
  // bool _isPreviousStateKilled = false;
  bool isPreviousStateKilled = false;


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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check if the previous state is killed
      _checkPreviousState();
    }
  }

  Future<void> _checkPreviousState() async {
     isPreviousStateKilled = false;

    try {
      final result = await exit(0);
      if (result != null) {
        isPreviousStateKilled = result;
      }
    } catch (e) {
      print('Error checking previous state: $e');
    }

    setState(() {
      isPreviousStateKilled = !isPreviousStateKilled;
    });
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await DefaultCacheManager().emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
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
                    'Step 3 of 3',
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
                height: 26,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 10),
                    child: Text(
                      'What are your Sexual\n Preferences?',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    PickChip(
                      icon: 'assets/icons/man.png',
                      title: 'Male',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/woman.png',
                      title: 'Female',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/gender.png',
                      title: 'Transman',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/Union 7.png',
                      title: 'Transwoman',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/male_female.png',
                      title: 'Transfeminine',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/bigender.png',
                      title: 'Bigender',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/transMac.png',
                      title: 'TransMaculine',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/non-binary.png',
                      title: 'Non-binary',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/agender.png',
                      title: 'Agender',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/genderqueer.png',
                      title: 'GenderQueer',
                      selectedValues: selectedValues,
                    ),
                    PickChip(
                      icon: 'assets/icons/gender-symbols.png',
                      title: 'Gender-fluid',
                      selectedValues: selectedValues,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 26,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 10),
                    child: Text(
                      'What kind of relationship are\n you looking for?',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    PickChip(
                      icon: 'assets/icons/couple-picture.png',
                      title: 'Casual Dating',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/love.png',
                      title: 'Serious Relationship',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/hockup.png',
                      title: 'Hock Up',
                      selectedValues: selectedValues,

                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 26,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 10),
                    child: Text(
                      'Pick some Hobbies',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    PickChip(
                      icon: 'assets/icons/sports.png',
                      title: 'Sports',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/grill.png',
                      title: 'Cooking',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/guitar.png',
                      title: 'Instruments',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/music.png',
                      title: 'Music',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/fox.png',
                      title: 'Love Animals',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/reading.png',
                      title: 'Reading',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/pen.png',
                      title: 'Writing',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/vide.png',
                      title: 'Video',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/photo.png',
                      title: 'Photography',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/rap.png',
                      title: 'Raping',
                      selectedValues: selectedValues,

                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    PickChip(
                      icon: 'assets/icons/tv.png',
                      title: 'Watching Tv',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/singing.png',
                      title: 'Singing',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/paint.png',
                      title: 'Painting',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/acting.png',
                      title: 'Acting',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/eating.png',
                      title: 'Eating Food',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/shoping.png',
                      title: 'Shopping',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/hiking.png',
                      title: 'Hicking',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/draw.png',
                      title: 'Drawing',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/swim.png',
                      title: 'Swimming',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/danc.png',
                      title: 'Dancing',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/garden.png',
                      title: 'Gardening',
                      selectedValues: selectedValues,

                    ),
                    PickChip(
                      icon: 'assets/icons/game.png',
                      title: 'Gaming',
                      selectedValues: selectedValues,

                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),

              isUploaded
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : CustomButton(
                txt: 'Continue',
                ontap: () async {
                  try {

                      setState(() {
                        isUploaded = true;
                      });
                     User? user = FirebaseAuth.instance.currentUser;
                      final time = DateTime.now().millisecondsSinceEpoch.toString();

                      if (user != null) {
                        final documentReference = await FirebaseFirestore
                            .instance
                            .collection('user')
                            .doc(user.uid);
                        userData = UserData(
                          name: userData!.name,
                          email: userData!.email,
                          id: user.uid,
                          haveCar: userData!.haveCar,
                          age: userData!.age,
                          height: userData!.height,
                          weight: userData!.weight,
                          imageOne: userData!.imageOne,
                          imageTwo: userData!.imageTwo,
                          flower: 5,
                          dataComplete:'Complete',
                          pushToken: userData!.pushToken,
                          createdAt: time,
                          isOnline: false,
                          lastActive: time,
                          // time: DateTime.timestamp(),
                          timestamp : Timestamp.fromDate(DateTime.now()),


                          maximumSpend: userData!.maximumSpend,
                          minimumSpend: userData!.minimumSpend,
                          gender: userData!.gender,
                          latituelocation:
                          userData!.latituelocation!.toDouble(),
                          longitudelocation:
                          userData!.longitudelocation!.toDouble(),
                          tags: selectedValues,


                        );
                        await documentReference.id;
                        await documentReference
                            .update(userData!.toMap())
                            .then(
                              (value) {
                            setState(() {
                              isUploaded = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BottomBar(selectedIndex: 0,)), // Replace "HomeScreen()" with your app's home screen.
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                content: Text(
                                  "Added SuccessFully",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      }
                      throw FormatException('Errors');


                  }
                  on FirebaseAuthException catch (e) {
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
                },
              ),

              // CustomButton(
              //   txt: 'Continue',
              //   ontap: () {
              //     // Iterate through the list of PickChip widgets and get the selected titles
              //     for (PickChip pickChip in list) {
              //       selectedValues.add(pickChip.title!);
              //     }
              //     saveSelectedValues(selectedValues).then((value) {
              //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar()));
              //     });
              //   },
              // ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PickChip> list = [];

  Future<void> saveSelectedValues(List<String> selectedValues) async {
    try {
      final DocumentReference<Map<String, dynamic>> tagsCollection =
          FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid);
      await tagsCollection.set({'tags': selectedValues,});
      print('Selected values saved to Firestore');
    } catch (e) {
      print('Error saving selected values: $e');
    }
  }
}

class PickChip extends StatefulWidget {
  String? title;
  String? icon;
  List<String>? selectedValues;

  PickChip({Key? key, this.title, this.icon, this.selectedValues})
      : super(key: key);

  @override
  State<PickChip> createState() => _PickChipState();
}

class _PickChipState extends State<PickChip> {
  List list = [];
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7, top: 8),
      child: ChoiceChip(
        selectedShadowColor: Color(0xffAC832F),
        side: BorderSide(
          color: _isSelected ? Color(0xffE6C758) : Colors.transparent,
          width: _isSelected ? 4 : 0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        label: Column(
          children: [
            Image.asset(
              '${widget.icon}',
              scale: 5,
              color: Colors.white,
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
        selected: _isSelected,
        onSelected: (isSelected) {
          setState(() {
            _isSelected = isSelected;
            if (isSelected) {
              widget.selectedValues!.add(widget.title!);
            } else {
              widget.selectedValues!.remove(widget.title);
            }
          });
        },
        selectedColor: primaryColor,
      ),
    );
  }
}
