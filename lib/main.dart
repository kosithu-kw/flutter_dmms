import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'error.dart';

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
    Timer(Duration(seconds: 3), () => checkConnection());
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


