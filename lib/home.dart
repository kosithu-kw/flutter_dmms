import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'error.dart';
import 's_filter.dart';
import 'package:share/share.dart';


class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  getData() async{
    var res=await http.get(Uri.https('raw.githubusercontent.com', "kosithu-kw/dmms_data/master/sayartaws.json"));
    var jsonData=jsonDecode(res.body);
    return jsonData;
  }

  final String _title="ဓမ္မမိတ်ဆွေ";
  final String _subTitle="ဆရာတော်ဘုရားကြီးများ";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _subTitle,
      home: Scaffold(

        appBar: AppBar(
          centerTitle: true,
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
              /*
                Container(
                  child: Text(_subTitle,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 2.0
                      )),
                )

                 */
            ],
          ),
        ),


        /*
          appBar: AppBar(
            centerTitle: true,
            title: Text(_title, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 20.0),),
          //  elevation: 10,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Color.fromRGBO(0, 0, 0, 1)
            ),

            bottom: PreferredSize(
              child: Text(_subTitle,
                  style: TextStyle(
                      color: Colors.black,
                      height: 2.0
                  )),
              preferredSize: Size.fromHeight(15),

            ),


          ),

           */
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("App Version"),
                subtitle: Text("1.0.0"),
                leading: Icon(Icons.settings_accessibility),
                onTap: (){
                  Navigator.of(context).pushNamed("/home");
                },
              ),
              ListTile(
                title: Text("Share App"),
                leading: Icon(Icons.share),
                onTap: (){
                  Share.share("https://play.google.com/store/apps/details?id=com.goldenmawlamyine.dmms");
                },
              )
            ],
          ),

        ),
        body: Container(
          child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot s){
              if(s.hasData){
                return ListView.builder(
                    itemCount: s.data.length,
                    itemBuilder: (context, i){
                      return Card(
                        child: ListTile(
                          onTap: (){
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (BuildContext context)=>new Sfilter(data: s.data[i])));
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(s.data[i]['s_image']),
                          ),
                          title: Text(s.data[i]['s_name']),
                          trailing: Icon(Icons.navigate_next),
                          // trailing: Icon(Icons.navigate_next),
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
      ),
    );
  }
}
