import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dmms/sayardaw.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Quote extends StatefulWidget {
  const Quote({Key? key}) : super(key: key);

  @override
  _QuoteState createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {

  String _title="", _content="", _credit="";
  bool _isData=false;

  _getQuote()async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/dmms_data/master/quote.json");
    var doc=await result.readAsString();
    var jsonData=await jsonDecode(doc);
    // print(jsonData['title']);
    setState(() {
      _title=jsonData['title'];
      _content=jsonData['content'];
      _credit=jsonData['credit'];
      _isData=true;
    });
  }

  @override
  void initState() {
    _getQuote();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Center(
        child:
        !_isData ?
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 100),
          child: CircularProgressIndicator(
            color: Colors.black,
            backgroundColor: Colors.grey,
          ),
        )
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              child: Text(_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20,top: 20),
              child: Text(_content,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ),

            Container(
              child: Text(_credit,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            )


          ],
        ),
      ),

    );
  }
}

