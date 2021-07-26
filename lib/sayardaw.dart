import 'dart:convert';
import 'package:dmms/readme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'error.dart';
import 'dart:async';
import 'home.dart';
import 's_filter.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          return  await Navigator.pushReplacement(context, PageTransition(child: Home(), type: PageTransitionType.rightToLeft));
        },
        child: MaterialApp(
          title: _subTitle,
          home: Scaffold(

            appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton(onPressed: (){
                  _updateData();
                },
                  icon: Icon(Icons.cloud_download),
                ),
              ],
              toolbarHeight: 80,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                  color: Color.fromRGBO(0, 0, 0, 1)
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    child: Text(_subTitle,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 20
                      ),

                    ),
                  ),

                ],
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
            floatingActionButton: FloatingActionButton(
              onPressed: (){

                Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeft, child: Home()));

              },
              child: Icon(Icons.home_outlined, color: Colors.black,),
              backgroundColor: Colors.white70,
            ),
            body: Container(
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
          ),
        )
    );
  }
}
