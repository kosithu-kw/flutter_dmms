import 'dart:convert';
import 'package:dmms/confirm_exit.dart';
import 'package:dmms/readme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'ad_helper.dart';
import 'error.dart';
import 'dart:async';
import 'home.dart';
import 's_filter.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Sayardaw extends StatefulWidget {
  const Sayardaw({Key? key}) : super(key: key);

  @override
  _SayardawState createState() => _SayardawState();
}

class _SayardawState extends State<Sayardaw> {
  getData() async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/dmms_data/master/sayartaws.json");
    var file=await result.readAsString();
    var jsonData=jsonDecode(file);
    return jsonData;
  }

  bool _isUpdate=false;

  _updateData() async{
    await DefaultCacheManager().emptyCache().then((value){
      setState(() {
        _isUpdate=true;

      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          _isUpdate=false;
        });
      });
    });
  }


  final String _title="ဓမ္မမိတ်ဆွေ";
  final String _subTitle="ဆရာတော်ဘုရားကြီးများ";


  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

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
      _callBannerAds();
    }
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          return  await Navigator.pushReplacement(context, PageTransition(child:ConfirmExit(), type: PageTransitionType.rightToLeft));
        },
        child: MaterialApp(
          title: _subTitle,
          home: Scaffold(

            appBar: AppBar(
              actions: [
                IconButton(onPressed: (){
                  _updateData();
                },
                  icon: Icon(Icons.cloud_download),
                ),
              ],
              //toolbarHeight: 80,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                  color: Color.fromRGBO(0, 0, 0, 1)
              ),
              title: Text(_subTitle,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          //fontSize: 20
                      ),

                    ),

            ),


            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("App Version"),
                    subtitle: Text("1.0.0"),
                    leading: Icon(Icons.settings_accessibility),

                  ),
                  /*
              ListTile(
                title: Text("Share App"),
                leading: Icon(Icons.share),
                onTap: (){
                  Share.share("https://play.google.com/store/apps/details?id=com.goldenmawlamyine.dmms");
                },
              ),

               */
                  ListTile(
                    title: Text("Read Me"),
                    leading: Icon(Icons.book),
                    onTap: (){
                      Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeft, child: ReadmeApp()));
                    },
                  )
                ],
              ),

            ),

            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration:BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 55.0,
                                color: Colors.white
                            )
                        )
                    ),
                    padding: EdgeInsets.all(5),
                    child: FutureBuilder(
                      future: _isUpdate ? getData() : getData(),
                      builder: (context, AsyncSnapshot s){
                        if(_isUpdate)
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 120, right: 120),
                                  child: LinearProgressIndicator(),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text("Updating data from server..."),
                                )
                              ],
                            ),
                          );

                        if(s.hasData){
                          final orientation = MediaQuery.of(context).orientation;

                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 1.8),
                            ),
                            shrinkWrap: true,
                            itemBuilder: (_, i) {
                              return InkWell(
                                  onTap: (){
                                    Navigator.of(context).pushReplacement(PageTransition(child: Sfilter(data: s.data[i]), type: PageTransitionType.rightToLeft));

                                  },
                                  child: Card(
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5, top: 5),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              child: Container(
                                               // margin: EdgeInsets.only(bottom: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.yellowAccent.withOpacity(0.3),
                                                      spreadRadius: 10,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 4), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                               // padding: EdgeInsets.all(5),
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: "${s.data[i]['s_image']}",
                                                    height: 120,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                        CircularProgressIndicator(value: downloadProgress.progress,
                                                          color: Colors.white70,
                                                          backgroundColor: Colors.red.withOpacity(0.3),
                                                        ),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                  ),
                                                )
                                              ),
                                            )
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding: EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.9)
                                              ),
                                              child:  Text("${s.data[i]['s_name']}", textAlign: TextAlign.center, style: TextStyle(color: Colors.black,height: 1.5),),
                                            ),
                                          )
                                          //Text("၏တရားတော်များ", style: TextStyle(fontSize: 12, color: Colors.grey) ,),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                            itemCount: s.data.length,
                          );

                        }else if(s.hasError){
                          return Center(
                              child: IconButton(
                                onPressed: (){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => new ErrorApp()));
                                },
                                icon: Icon(Icons.refresh_outlined),
                                color: Colors.black,
                              )
                          );
                        }else{
                          return Container(
                            padding: EdgeInsets.only(left: 100, right: 100),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                                backgroundColor: Colors.black,
                              ),
                            ),
                          );
                        }
                      },
                    ),
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
        )
    );
  }
}

/*
return ListView.builder(
                        itemCount: s.data.length,
                        itemBuilder: (context, i){
                          return Card(
                              child:Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: ListTile(
                                  onTap: (){
                                    // Navigator.of(context).push(PageTransition(child: Sfilter(data: s.data[i]), type: PageTransitionType.rightToLeft));
                                    Navigator.of(context).pushReplacement(PageTransition(child: Sfilter(data: s.data[i]), type: PageTransitionType.rightToLeft));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(s.data[i]['s_image']),
                                  ),
                                  title: Text(s.data[i]['s_name']),
                                  subtitle: Text("၏တရားတော်များ"),
                                  trailing: Icon(Icons.navigate_next),
                                  // trailing: Icon(Icons.navigate_next),
                                ),
                              )
                          );
                        }
                    );
 */