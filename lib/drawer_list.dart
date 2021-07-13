import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 's_filter.dart';


getData() async{
  var res=await http.get(Uri.https('raw.githubusercontent.com', "kosithu-kw/dmms_data/master/sayartaws.json"));
  var jsonData=jsonDecode(res.body);
  return jsonData;
}


class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                      // trailing: Icon(Icons.navigate_next),
                    ),

                  );
                }
            );
          }else if(s.hasError){
            return Center(
              child: Text("${s.error}"),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
