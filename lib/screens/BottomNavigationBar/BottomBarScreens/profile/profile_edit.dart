import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:love_roulette/Constant/color.dart';
import 'package:love_roulette/Widegts/custom_btn.dart';

import '../../../../Models/user_data.dart';

class ProfileEditScreen extends StatefulWidget {
  String? naaam;
  String? ag;
  String? amount;

  ProfileEditScreen({this.ag, this.naaam,this.amount, Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  UserData? userData;
  String? name;
  String? age;
  String? imgtwo;
  String? img;
  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController nameC = TextEditingController();
  TextEditingController ageC = TextEditingController();
  TextEditingController amountC = TextEditingController();

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  String dropdownValueTwo = 'Car';



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
          imgtwo = '${userData!.imageTwo}';
          name = userData!.name;
          age = userData!.age;
        }
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getConnectivity();

    nameC.text = widget.naaam.toString();
    ageC.text = widget.ag.toString();
    amountC.text = widget.amount.toString();
  }

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidtg = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/images/back.png',
            scale: 1.5,
          ),
        ),
        backgroundColor: primaryColor,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
          textScaleFactor: 1.0,
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30,
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
                            child: CachedNetworkImage(
                              height: screenHeight / 5,
                              width: screenWidtg / 2.4,
                              imageUrl: "${img}",
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                child: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),
                  ),

                  //2nd img

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
                            child: CachedNetworkImage(
                              height: screenHeight / 5,
                              width: screenWidtg / 2.4,
                              imageUrl: "${imgtwo}",
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                child: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),
                  ),

                  //name
                ],
              ),

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  children: [
                    Text(
                      'User Name',
                      style: GoogleFonts.montserrat(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: screenWidtg / 1.12,
                height: 70,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Update Name';
                    }
                  },
                  onChanged: (newValue) {
                    // Update the textFieldValue whenever the text field is edited
                    setState(() {
                      name = newValue;
                    });
                  },
                  controller: nameC,
                  decoration: InputDecoration(
                    suffixIconColor: whiteColor,
                    contentPadding:
                        EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                    border: InputBorder.none,
                    // hintText: name.toString(),
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

              //age

              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  children: [
                    Text(
                      'User Age',
                      style: GoogleFonts.montserrat(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

              SizedBox(
                width: screenWidtg / 1.12,
                height: 70,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Update Age';
                    }
                  },
                  controller: ageC,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    suffixIconColor: whiteColor,
                    contentPadding:
                        EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                    border: InputBorder.none,
                    // hintText: age.toString(),

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

              //maxiimum spend


              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  children: [
                    Text(
                      'Maximum Spend',
                      style: GoogleFonts.montserrat(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

              SizedBox(
                width: screenWidtg / 1.12,
                height: 70,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  // ignore: body_might_complete_normally_nullable
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Update Amount';
                    }
                  },
                  controller: amountC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    suffixIconColor: whiteColor,
                    contentPadding:
                    EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                    border: InputBorder.none,
                    // hintText: age.toString(),

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



              //car change

              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  children: [
                    Text(
                      'Change Convance',
                      style: GoogleFonts.montserrat(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

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

              //button

              SizedBox(
                height: 30,
              ),
              isUploaded
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : CustomButton(
                      txt: 'Confrim',
                      ontap: () async {
                        try {
                          if (formKey.currentState!.validate()) {
                            User? user = FirebaseAuth.instance.currentUser;

                            setState(() {
                              isUploaded = true;
                            });

                            final time = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();

                            if (user != null) {
                              final documentReference = await FirebaseFirestore
                                  .instance
                                  .collection('user')
                                  .doc(user.uid);
                              userData = UserData(
                                name: nameC.text.toString(),
                                email: userData!.email,
                                id: user.uid,
                                age: ageC.text.toString(),
                                height: userData!.height,
                                weight: userData!.weight,
                                imageOne: userData!.imageOne,
                                imageTwo: userData!.imageTwo,
                                createdAt: time,
                                haveCar: dropdownValueTwo,
                                pushToken: userData!.pushToken,
                                dataComplete:'Complete',

                                isOnline: false,
                                lastActive: time,
                                flower: userData!.flower,
                                maximumSpend: double.parse(amountC.text.toString()),
                                minimumSpend: userData!.minimumSpend,
                                gender: userData!.gender,
                                latituelocation:
                                    userData!.latituelocation!.toDouble(),
                                longitudelocation:
                                    userData!.longitudelocation!.toDouble(),
                                tags: userData!.tags,
                              );
                              await documentReference.id;
                              await documentReference
                                  .update(userData!.toMap())
                                  .then(
                                (value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      content: Text(
                                        "Profile Updated SuccessFully",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 19),
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              );
                            }
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
                              style:
                                  TextStyle(color: primaryColor, fontSize: 19),
                            ),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                    ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
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
      // setState(() {
      //   isUploaded = true;
      // });
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
      // setState(() {
      //   isUploaded = true;
      // });
    });
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirebase() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
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
                'Update Profile\n photos',
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
                      String urlOne = await uploadFileOne(_imageOne!);
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(user.uid)
                          .update({
                        "imageOne": urlOne,
                      });
                      uploadFileTwo(_imageOne!);
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
                      String urlOne = await uploadFileOne(_imageOne!);
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(user.uid)
                          .update({
                        "imageOne": urlOne,
                      });
                      uploadFileTwo(_imageOne!);

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
                'Update Profile\n photos',
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

                      String urlOne = await uploadFileOne(_imageTwo!);
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(user.uid)
                          .update({
                        "imageTwo": urlOne,
                      });
                      uploadFileTwo(_imageTwo!);

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

                      String urlOne = await uploadFileOne(_imageTwo!);
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(user.uid)
                          .update({
                        "imageTwo": urlOne,
                      });
                      uploadFileTwo(_imageTwo!);

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
