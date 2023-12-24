import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../models/user_data.dart';
import '../Constant/color.dart';
import '../screens/SignUpScreen/continue_screen.dart';

class CustomGoogleMap extends StatefulWidget {
  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  UserData? userData;
  String? firstName;

  final user = FirebaseAuth.instance.currentUser!;

  getUserData() async {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: user.uid)
        .get();
    if (res.docs.isNotEmpty) {
      setState(() {
        userData =
            UserData.fromMap(res.docs.first.data() as Map<String, dynamic>);
      });
    }
  }

  LatLng _intitialcamerapositon = LatLng(30.6952325, 73.0904565);

  // static const LatLng sourceLocation = LatLng(20.597, 78.9629);
  // static const LatLng DestinationLocation = LatLng(20.597, 78.8758);

  // Set<Marker> markers = Set();

  Location location = Location();
  GoogleMapController? controller;

  void _onMapCreated(GoogleMapController value) {
    controller = value;
    location.onLocationChanged.listen((event) {
      // if(controller!.isCompleted){
      //   controller!.complete(controller);
      // }

      controller!.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(double.parse(event.latitude.toString()),
              double.parse(event.longitude.toString())),
          20));

      // CameraUpdate.newCameraPosition(
      //   CameraPosition(
      //     target: LatLng(
      //       double.parse(event.latitude.toString()),
      //       double.parse(event.longitude.toString()),
      //     ),
      //     zoom: 20,
      //   ),
      // ),
    });
  }

  //
  // List<Marker> marker = [];
  // List<Marker> listMarker = const [
  //   Marker(
  //     markerId: MarkerId('1'),
  //     position: LatLng(20.597, 78.9629),
  //     infoWindow: InfoWindow(title: 'ISB'),
  //     icon: BitmapDescriptor.defaultMarker,
  //   ),
  //
  // ];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // marker.addAll(listMarker);

    getUserData();
    controller;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller;
  }

  @override
  Widget build(BuildContext context) {
    // CheckOutProvider checkOutProvider = Provider.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.red,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     'Google Map Adress',
      //     style: TextStyle(
      //       fontSize: 18,
      //       color: Colors.red,
      //     ),
      //   ),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _intitialcamerapositon,
              ),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              // markers: Set<Marker>.of(marker),
            ),
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          left: 10, right: 60, top: 40, bottom: 40),
                      child: MaterialButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await location.getLocation().then((value) async {
                              // checkOutProvider.setLocation = value;
                              final times = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final User user = auth.currentUser!;
                              userData = UserData(
                                name: userData!.name!,
                                email: userData!.email,
                                id: user.uid,
                                age: userData!.age,
                                height: userData!.height,
                                weight: userData!.weight,
                                imageOne: '',
                                imageTwo: '',
                                maximumSpend: 0,
                                minimumSpend: 0,

                                gender: '',
                                latituelocation: value.latitude,
                                longitudelocation: value.longitude,
                                createdAt: times,
                                isOnline: false,
                                lastActive: times,
                                // tags:[],
                              );
                              return await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(user.uid)
                                  .set(userData!.toMap())
                                  .whenComplete(() {
                                Navigator.pop(context);
                              });
                            });
                            // throw FormatException('Errors');
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
                                style: TextStyle(
                                    color: primaryColor, fontSize: 19),
                              ),
                              duration: Duration(seconds: 2),
                            ));
                            // throw FormatException('Errors');
                          }
                        },
                        child: Text(
                          'Set Location',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: primaryColor,
                        shape: StadiumBorder(),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
