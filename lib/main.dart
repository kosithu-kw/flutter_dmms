import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dmms/readme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';
import 'error.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}


void main(){
  runApp(
    MaterialApp(
      title: 'MON RTL ROUTES',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
    //  theme: ThemeData(fontFamily: 'uni'),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MainApp(),

        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => Home(),
        '/error' : (context) => ErrorApp(),
        '/readme':(context)=> ReadmeApp()
      },
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MaterialApp(
          home: MainApp(),
        )
    );
  }
}




class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
      Navigator.pushNamed(context, "/home");
      //print("Not first time");

    } else {// First time
      prefs.setBool('first_time', false);

      checkConnection();
      //print("first time");
    }
  }


  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('raw.githubusercontent.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Home()));

      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () => startTime());

    _callIntMessage();
    super.initState();
  }

  _callIntMessage(){
    _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
  }




  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!, style: TextStyle(color: Colors.black),),
            leading: Image.asset("icon/icon.png"),
            subtitle: Text(_notificationInfo!.body!, style: TextStyle(color: Colors.black),),
            background: Colors.white,
            duration: Duration(seconds: 5),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }


  final String _mTitle="ဓမ္မမိတ်ဆွေ";
  final String _mSubTitle="တရားတော်များ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(
            child: Stack(
              children: [
                
               Center(
                 child:  Container(
                   child: Image.asset("assets/images/logo.png", width: 120,),
                 ),
               ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 50,
                      margin: EdgeInsets.only(bottom: 50),
                      child: LinearProgressIndicator(
                        color: Colors.grey,
                        backgroundColor: Colors.black,
                      )
                  ),
                )
              ],
            ),
          ),
        ),

    );
  }
}


class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
