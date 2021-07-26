import 'dart:async';
import 'dart:convert';
import 'dart:io';
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


    super.initState();
  }
  final String _subTitle="တရားတော်များ";


  @override
  Widget build(BuildContext context) {
  return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Sayardaw()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            _updateData();
          },
            icon: Icon(Icons.cloud_download),
          ),
        ],
        toolbarHeight: 125,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Color.fromRGBO(0, 0, 0, 1)
        ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child:  CircleAvatar(
                    backgroundImage: NetworkImage(widget.data['s_image'], ),
                  ),
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
                        color: Colors.black,
                        fontSize: 16,
                        height: 2.0
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
                return ListView.builder(
                      itemCount: s.data.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (BuildContext context)=>new MyPlayer(data: s.data[i])));
                            },

                            title: Text(s.data[i]['d_title']),
                            leading: Icon(Icons.play_circle,color: Colors.black,),
                            subtitle: Text(s.data[i]['s_name']),
                          ),

                        );
                      }
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
