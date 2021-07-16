import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'home.dart';

class ErrorApp extends StatefulWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  _ErrorAppState createState() => _ErrorAppState();
}

class _ErrorAppState extends State<ErrorApp> {

  bool _isLoading=false;
  String _tryText= "အင်တာနက်ဆက်သွယ်မှုများပြတ်တောက်နေပါသည်";
  String _secondText="Need internet connection for first time user";

  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('raw.githubusercontent.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> HomeApp()));
      }
    } on SocketException catch (_) {
      Timer(Duration(seconds: 3), (){
        setState(() {
          _isLoading=false;
          _tryText="အင်တာနက်ဆက်သွယ်မှုများပြတ်တောက်နေပါသည်";
          _secondText="Need internet connection for first time user";

        });
        // Navigator.pushNamed(context, '/error');
      });

      //Navigator.pushNamed(context, '/error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Error",
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_isLoading)
                Container(
                  padding: EdgeInsets.only(left: 150, right: 150, bottom: 30),
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                ),
              Container(
                child: Icon(Icons.wifi_off_outlined, size: 30,),
              ),
              Container(
                child: Center(
                  child: Text(
                      _tryText
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Center(
                  child: Text(
                      _secondText
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: TextButton(
                    child: Text("Try Again", style: TextStyle(color: Colors.black),),
                    onPressed: (){
                      setState(() {
                        _isLoading=true;
                        _tryText="ပြန်လည်ချိတ်ဆက်နေသည်...";
                      });
                      checkConnection();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}