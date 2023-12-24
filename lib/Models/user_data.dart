import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? imageOne;
  String? imageTwo;
  String? name;
  String? id;

  int? flower;

  String? dataComplete;

  String? age;
  String? height;
  double? weight;
  String? gender;
  double? minimumSpend;
  double? maximumSpend;

  String? email;

  String? haveCar;

  double? latituelocation;
  double? longitudelocation;

  bool? isOnline;
  String? createdAt;
  String? lastActive;
  Timestamp? timestamp;

  String? pushToken;

  List<String>? tags;

  UserData({
    this.tags = const [],
    this.name,
    this.email,
    this.pushToken,
    this.id,

    this.dataComplete,

    this.imageOne,
    this.imageTwo,
    this.latituelocation,
    this.longitudelocation,
    this.height,
    this.weight,
    this.age,
    this.haveCar,
    this.gender,
    this.maximumSpend,
    this.minimumSpend,
    this.timestamp,
    this.createdAt,
    this.isOnline,
    this.flower,
    this.lastActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageOne': imageOne,
      'imageTwo': imageTwo,
      'name': name,
      'pushToken': pushToken,
      'haveCar': haveCar,
      'id': id,
      'dataComplete' :dataComplete,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'minimumSpend': minimumSpend,
      'maximumSpend': maximumSpend,
      'email': email,
      'latituelocation': latituelocation,
      'longitudelocation': longitudelocation,
      'isOnline': isOnline,
      'createdAt': createdAt,
      'lastActive': lastActive,
      'timestamp': timestamp,
      'tags': tags,
      'flower': flower,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      imageOne: map['imageOne'],
      imageTwo: map['imageTwo'],
      name: map['name'],
      haveCar: map['haveCar'],
      pushToken: map['pushToken'] ?? '',
      id: map['id'],
      flower: map['flower'] ?? 0,
      age: map['age'],

      dataComplete : map['dataComplete'],

      height: map['height'],
      weight: map['weight'],
      gender: map['gender'],
      minimumSpend: map['minimumSpend'],
      maximumSpend: map['maximumSpend'],
      email: map['email'],
      latituelocation: map['latituelocation'],
      longitudelocation: map['longitudelocation'],
      isOnline: map['isOnline'],
      createdAt: map['createdAt'],
      lastActive: map['lastActive'],
      timestamp: map['timestamp'],
      tags: List<String>.from(map['tags']),
    );
  }
}
