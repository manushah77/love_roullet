import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../Constant/color.dart';
import '../../Models/accepted_model.dart';
import '../../Models/user_data.dart';
import '../../Widegts/custom_btn.dart';
import '../../chat_widget/chat_user_card.dart';
import '../SignUpScreen/Auth_code/auth_code.dart';

class FlowerSreen extends StatefulWidget {
  const FlowerSreen({Key? key}) : super(key: key);

  @override
  State<FlowerSreen> createState() => _FlowerSreenState();
}

class _FlowerSreenState extends State<FlowerSreen> {
  // for storing user data
  List<AcceptedDateData> list = [];

  // for storing search item
  final List<AcceptedDateData> _searchList = [];

  // for storing search status
  bool isSearching = false;
  AuthWork? auth;
  List<AcceptedDateData> userData = [];
  UserData? userdata;
  UserData? userdataTwo;

  String? datingMemberId;
  String? datedMemberId;

  final user = FirebaseAuth.instance.currentUser!;

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
        .collection('ContactCollection')
        .where('DatingMemberId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (res.docs.isNotEmpty)
      setState(() {
        {
          userData = res.docs
              .map((e) =>
                  AcceptedDateData.fromMap(e.data() as Map<String, dynamic>))
              .toList();

          for (var item in userData) {
            datingMemberId = item.DatingMemberId!;
            datedMemberId = item.DatedMemberId!;

            // Use the retrieved IDs as desired
            print('DatingMemberId: $datingMemberId');
            print('DatedMemberId: $datedMemberId');
          }
        }
      });

    //all user
    QuerySnapshot rest = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: datedMemberId)
        .get();
    if (rest.docs.isNotEmpty)
      setState(() {
        {
          // userdata = rest.docs
          //     .map((e) =>
          //     UserData.fromMap(e.data() as Map<String, dynamic>))
          //     .toList();
          userdata =
              UserData.fromMap(rest.docs.first.data() as Map<String, dynamic>);
        }
      });

    //all user
    QuerySnapshot re = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: datingMemberId)
        .get();
    if (re.docs.isNotEmpty)
      setState(() {
        {
          // userdata = rest.docs
          //     .map((e) =>
          //     UserData.fromMap(e.data() as Map<String, dynamic>))
          //     .toList();
          userdataTwo =
              UserData.fromMap(re.docs.first.data() as Map<String, dynamic>);
        }
      });
  }

  TextEditingController sndC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message) {
      // Handle system lifecycle events here
      return Future.value(message);
    });
    getData();
    getConnectivity();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: Icon(
              isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : CupertinoIcons.search,
            ),
          ),
        ],
        title: isSearching
            ? TextFormField(
                onChanged: (val) {
                  // search logic
                  _searchList.clear();
                  for (var i in list) {
                    if (i.DatedMemberName!
                            .toLowerCase()
                            .contains(val.toLowerCase()) ||
                        i.DatedMemberAge!
                            .toLowerCase()
                            .contains(val.toLowerCase())) {
                      _searchList.add(i);
                    }
                  }
                  setState(() {
                    _searchList;
                  });
                },
                style: TextStyle(
                    color: whiteColor, fontSize: 16, letterSpacing: 1),
                cursorColor: whiteColor,
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search People',
                    hintStyle: TextStyle(color: whiteColor, fontSize: 16)),
              )
            : Text(
                'Send Flowers',
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: whiteColor,
                ),
                textScaleFactor: 1.0,
              ),
      ),
      body: userData.isEmpty
          ? Center(
              child: Container(
                height: 300,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/nochat.png',
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      'No User Found',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  opacity: 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('ContactCollection')
                      .where('DatingMemberId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(), // Update with your stream
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                            strokeWidth: 2,
                          ),
                        );

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        list = data?.map((e) {
                              final userData =
                                  AcceptedDateData.fromMap(e.data());
                              return userData;
                            }).toList() ??
                            [];

                        if (list.isNotEmpty) {
                          return Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .01),
                                      itemCount: isSearching
                                          ? _searchList.length
                                          : list.length,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              showbottomsheet(index);
                                            },
                                            child: ListTile(
                                              tileColor:
                                                  Colors.grey.withOpacity(0.2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              leading: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(0xffFFE2A9),
                                                      width: 1.5,
                                                    ),
                                                    shape: BoxShape.circle),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .10),
                                                  child: CachedNetworkImage(
                                                    height: 50,
                                                    width: 50,
                                                    imageUrl:
                                                        "${userData[index].DatedMemberImage}",
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            CircleAvatar(
                                                      child: Icon(CupertinoIcons
                                                          .person),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                '${userData[index].DatedMemberName}',
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Text('No users found'),
                          );
                        }
                    }
                  }),
            ),
    );
  }

  void showbottomsheet(int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: formKey,
          child: Container(
            height: 260,
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'How Many Flowers You \n Want To Send',
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 23.0),
                      child: Text(
                        'Send Flowers',
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 23.0),
                      child: Text(
                        // 'You Have ${userdataTwo!.flower} Flowers',
                        '',
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: GoogleFonts.openSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    // ignore: body_might_complete_normally_nullable
                    validator: (value) {
                      if (value == '' || value == null) {
                        return 'Send Flowers';
                      }
                    },
                    controller: sndC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIconColor: whiteColor,
                      contentPadding: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 5),
                      border: InputBorder.none,
                      hintText: '10',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black38,
                      ),
                      filled: true,
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent)),
                      fillColor: Colors.grey.withOpacity(0.2),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(datedMemberId!)
                          .update({
                        // 'flower': userdata!.flower! + int.parse(sndC.text),
                      });
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(datingMemberId)
                          .update({
                        // 'flower': userdata!.flower! - int.parse(sndC.text),
                      });
                      Navigator.pop(context);
                      sndC.clear();
                    }
                    // FirebaseFirestore.instance
                    //     .collection('ContactCollection')
                    //     .doc(datingMemberId!+datedMemberId!)
                    //     .update({
                    //   'flower': userData[index].Flower!-int.parse(sndC.text),
                    // });
                  },
                  child: Container(
                    height: 60,
                    width: 170,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffFBE978),
                          Color(0xffF8DC65),
                          Color(0xffE6C758),
                          Color(0xffFFFB90),
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
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Send',
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
          ),
        ),
      ),
    );
  }
}
