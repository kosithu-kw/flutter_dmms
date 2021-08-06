import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmms/player.dart';
import 'package:dmms/sayardaw.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'error.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'home.dart';



class Sfilter extends StatefulWidget {
  final data;
  const Sfilter({Key? key , required this.data}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<Sfilter> {


  _getAllDhamma() async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/dmms_data/master/${widget.data['s_url']}");
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



  /*
  getData() async{
    var res=await http.get(Uri.https('raw.githubusercontent.com', "kosithu-kw/dmms_data/master/dhamma.json"));
    var jsonData=jsonDecode(res.body);
    return jsonData;

  }

   */

  @override
  void initState() {
    // TODO: implement initState
   // print(widget.data);
    setState(() {

    });

    super.initState();
  }
  final String _subTitle="၏တရားတော်များ";


  @override
  Widget build(BuildContext context) {
  return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Sayardaw()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        /*
        actions: [

          IconButton(onPressed: (){
            _updateData();
          },
            icon: Icon(Icons.cloud_download),
          ),
        ],

         */
        toolbarHeight: 125,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 0, 0, 1)
        ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.3),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
               child:  ClipOval(
                 child: CachedNetworkImage(
                   imageUrl: "${widget.data['s_image']}",
                   height: 50,
                   progressIndicatorBuilder: (context, url, downloadProgress) =>
                       LinearProgressIndicator(value: downloadProgress.progress,
                         color: Colors.white70,
                         backgroundColor: Colors.red.withOpacity(0.3),
                       ),
                   errorWidget: (context, url, error) => Icon(Icons.error),
                 ),
               )

              ),
              Container(
                  child: Text(widget.data['s_name'],
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 18
                    ),

                  ),
              ),
              Container(
                child: Text(_subTitle,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5
                    )),
              )
            ],
          ),
      ),


        body: Container(
          child: FutureBuilder(
            future: _isUpdate ? _getAllDhamma() : _getAllDhamma(),
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
                  if(s.data.length < 1){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text("ဆရာတော်ဘုရားကြီး၏တရားတော်များ Server  ပေါ်တွင်မရှိသေးပါ။ နောက်ရက်တွေမှာပြန်လည်ကြိုးစားကြည့်ပါ။", textAlign: TextAlign.center,),
                      )
                    );
                  }else{
                    return ListView.builder(
                        itemCount: s.data.length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (BuildContext context)=>new MyPlayer(data: s.data[i])));
                              },

                              title: Text(s.data[i]['d_title'], style: TextStyle(height: 1.5, color: Colors.black),),
                              leading: Icon(Icons.play_circle,color: Colors.black,),
                              subtitle: Text(s.data[i]['s_name']),
                            ),

                          );
                        }
                    );

                  }
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
                    child: LinearProgressIndicator(
                      color: Colors.grey,
                      backgroundColor: Colors.black,
                    ),
                  ),
                );
              }

            },
          ),
        ),

    );
  }
}
