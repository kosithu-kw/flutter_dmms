import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dmms/readme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'error.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
        '/home': (context) => HomeApp(),
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
    return MaterialApp(
      home: MainApp(),
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
        Navigator.pushNamed(context, '/home');
      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () => startTime());
    super.initState();
  }


  final String _mTitle="ဓမ္မမိတ်ဆွေ";
  final String _mSubTitle="တရားတော်များ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                  padding: EdgeInsets.only(left: 80, right: 80, top: 80),
                  child: Image.asset("assets/images/logo.png"),
                ),
                
                Text(_mSubTitle),

                Container(
                  padding: EdgeInsets.all(140),
                  child: LinearProgressIndicator(
                    color: Colors.grey,
                    backgroundColor: Colors.black,
                  )
                )
              ],
            ),
          ),
        ),

    );
  }
}


