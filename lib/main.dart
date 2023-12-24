import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:love_roulette/screens/SplashScreen/splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey="pk_test_51NQTzdLcq76fpBhM4lpfDdnYBGgNPmpbubHK1hOUmJGQc5xlxG6DZ54XmtVrSv76GtAwSFDnmLW3hcWlkUHZkCkR00PXhCuwl6";

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error,stack) {
    FirebaseCrashlytics.instance.recordError(error, stack,fatal: true);
    return true;
  };
  FirebaseMessaging.onBackgroundMessage(firebaseMessgingBackgroundhandler);

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

}
@pragma('vm:entry-point')
Future<void> firebaseMessgingBackgroundhandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: SplashScreen(),
    );
  }
}
