import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dmms/ad_helper.dart';
import 'package:dmms/confirm_exit.dart';
import 'package:dmms/quote.dart';
import 'package:dmms/sayardaw.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  /*
  String BannerId="";
  bool showBanner=false;

  _getAdId() async{
    var result=await http.get(Uri.https("raw.githubusercontent.com", "kosithu-kw/dmms_data/master/ads.json"));
    var jsonData=await jsonDecode(result.body);
    //print(jsonData['banner']);

      if(jsonData['showBanner']=="true"){
        setState(() {
          BannerId=jsonData['banner'];
          showBanner=true;
        });
        _callBannerAds();

      }else{
        setState(() {
          showBanner=false;
        });
      }

  }

   */

  _callBannerAds(){
    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }





  @override
  void initState() {

   if(!_isBannerAdReady){
     //_callBannerAds();
   }
   // _getAdId();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
   // _bannerAd.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: ()async{
      return await Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmExit()));
    },
      child: MaterialApp(

        home: Scaffold(

          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20,left: 20, right: 20),
                  decoration: _isBannerAdReady ? BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 70.0,
                              color: Colors.white
                          )
                      )
                  ) : null,
                  child: Column(
                    children: [
                      Container(
                          child: Image.asset("assets/images/logo.png", height: 120,),
                      ),

                      Card(
                        child: Container(
                          height: 300,
                          child: Quote(),
                        ),
                      ),

                      Container(
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, PageTransition(child: Sayardaw(), type: PageTransitionType.rightToLeft));
                            },
                            child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Icon(Icons.play_circle_outline_sharp),
                                      SizedBox(width: 20,),
                                      Text("???????????????????????????????????????????????????????????????", style: TextStyle(color: Colors.black, fontSize: 16),)
                                    ],
                                  ),
                                )
                            ),
                          )
                      )
                    ],
                  )
                ),

                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.bottomCenter,
                      child: Container(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    ),

              ],
            ),
          )
        ),
      ),
    );
  }
}

/*
C                           enter(
                      child: Column (
                        children: [
                          Container(
                            child: Image.asset("assets/images/logo.png", height: 120,),
                          ),
                          Container(
                            child: Card(
                              child: Quote(),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                              child: InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context, PageTransition(child: Sayardaw(), type: PageTransitionType.rightToLeft));
                                },
                                child: Card(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Icon(Icons.play_circle_outline_sharp),
                                          SizedBox(width: 20,),
                                          Text("???????????????????????????????????????????????????????????????", style: TextStyle(color: Colors.black, fontSize: 16),)
                                        ],
                                      ),
                                    )
                                ),
                              )
                          )
                        ],
                      )
                  ),
 */


/*
class WithAds extends StatefulWidget {
  const WithAds({Key? key}) : super(key: key);

  @override
  _WithAdsState createState() => _WithAdsState();
}

class _WithAdsState extends State<WithAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 70, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 70.0,
                  color: Colors.white
              )
          )
      ),
      child: Center(
          child: Column (
            children: [
              Container(
                child: Image.asset("assets/images/logo.png", height: 120,),
              ),
              Container(
                child: Card(
                  child: Quote(),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                  child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, PageTransition(child: Sayardaw(), type: PageTransitionType.rightToLeft));
                    },
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(Icons.play_circle_outline_sharp),
                              SizedBox(width: 20,),
                              Text("???????????????????????????????????????????????????????????????", style: TextStyle(color: Colors.black, fontSize: 16),)
                            ],
                          ),
                        )
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
}

class WithoutAds extends StatefulWidget {
  const WithoutAds({Key? key}) : super(key: key);

  @override
  _WithoutAdsState createState() => _WithoutAdsState();
}

class _WithoutAdsState extends State<WithoutAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 70, bottom: 20, left: 20, right: 20),

      child: Center(
          child: Column (
            children: [
              Container(
                child: Image.asset("assets/images/logo.png", height: 120,),
              ),
              Container(
                child: Card(
                  child: Quote(),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                  child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, PageTransition(child: Sayardaw(), type: PageTransitionType.rightToLeft));
                    },
                    child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(Icons.play_circle_outline_sharp),
                              SizedBox(width: 20,),
                              Text("???????????????????????????????????????????????????????????????", style: TextStyle(color: Colors.black, fontSize: 16),)
                            ],
                          ),
                        )
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
}



 */