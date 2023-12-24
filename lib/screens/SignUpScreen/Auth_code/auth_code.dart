import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_roulette/Models/accepted_model.dart';
import 'package:love_roulette/Models/messege.dart';

import '../../../Models/user_data.dart';

class AuthWork {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;
  static late UserData me;


  //for gmail user

  static Future<void> createUserGmail() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final dataUser = UserData(
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
      isOnline: false,
      lastActive: time,

    );

    return await firestore
        .collection('user')
        .doc(user.uid)
        .set(dataUser.toMap());
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      AcceptedDateData user) {
    return firestore
        .collection('chats/${getConversationID(user.DatedMemberId!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }




  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      AcceptedDateData user) {
    return firestore
        .collection('chats/${getConversationID(user.DatedMemberId!)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }




  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      AcceptedDateData chatUser) {
    return firestore
        .collection('ContactCollection')
        .where('DatingMemberId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots(); // Update with your stream
  }



  //update read status of message
  static Future<void> updateMessageReadStatus(Messges message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId!)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('user').doc(user.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'pushToken': ,
    });
  }


  //delete message
  static Future<void> deleteMessage(Messges message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId!)}/messages/')
        .doc(message.sent)
        .delete();


  }


//send first msg

  static Future<void> sendFirstMessage(
      AcceptedDateData chatUser, String msg, Typee type) async {
    await firestore
        .collection('ContactCollection')
        .doc(chatUser.DatedMemberId!+user.uid)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }


  // for getting id's of known users from firestore database
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
  //   return firestore
  //       .collection('user')
  //       // .doc(user.uid)
  //       // .collection('my_users')
  //       .snapshots();
  // }






  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('Accepted')
        .where('DatingMemberId', isNotEqualTo: user.uid)
        .snapshots();
  }


  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
  //     List<String> userIds) {
  //   log('\nUserIds: $userIds');
  //
  //   return firestore
  //       .collection('user')
  //       .where('id',
  //       whereIn: userIds.isEmpty
  //           ? ['']
  //           : userIds) //because empty list throws an error
  //   // .where('id', isNotEqualTo: user.uid)
  //       .snapshots();
  // }


  // for sending message
  static Future<void> sendMessage(
      AcceptedDateData chatUser, String msg, Typee type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Messges message = Messges(
        toId: chatUser.DatedMemberId,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.DatedMemberId!)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser as UserData, type == Typee.text ? msg : 'image'));
  }


  // for sending push notification
  static Future<void> sendPushNotification(
      UserData chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.id,
        "notification": {
          "title": chatUser.name, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "some_data": "User ID: ${chatUser.id}",
        },
      };

      // var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      //     headers: {
      //       HttpHeaders.contentTypeHeader: 'application/json',
      //       HttpHeaders.authorizationHeader:
      //       'key=	AAAApaYAxO8:APA91bHRc6c5j_WKCiZETFxXIMRZHZFe-6shM3eDLFmXr6z6E6ASG9BwfkRSQp4W5eeBU0i4O_JjGGQZR5g0oShdVvSHgrRBIroE_4wkZzeqJKT2g4rCpJy7JkiCuag_PT-T5_5Bx4SO'
      //     },
      //     body: jsonEncode(body));
      // log('Response status: ${res.statusCode}');
      // log('Response body: ${res.body}');
    } catch (e) {
      // log('\nsendPushNotificationE: $e');
    }
  }


  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';


}
