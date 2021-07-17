import 'dart:convert';
import 'package:flutter/material.dart';




class ReadmeApp extends StatefulWidget {
  const ReadmeApp({Key? key}) : super(key: key);

  @override
  _ReadmeAppState createState() => _ReadmeAppState();
}

class _ReadmeAppState extends State<ReadmeApp> {
  final String _title="ဓမ္မမိတ်ဆွေ";
  final String _subTitle="သင့်အတွက်အင်္ဂလိပ်စာ";
  final String _readMeBody="ဓမ္မမိတ်ဆွေ Application ကိုပထမဦးဆုံးအကြိမ်အသုံးပြုခြင်းအတွက် Internet Connection ဖွင့်ထားရန်လိုအပ်ပါသည်၊ လိုအပ်ပါက VPN များချိတ်ဆက်အသုံးပြုရပါမည်။နောက်ပိုင်းအသုံးပြုခြင်း အတွက် ဆရာတော်များနှင့် တရားတော် စာရင်းများကို  Internet Connection ဖွင့်ထားရန်မလိုအပ်တော့ပဲ ကြည့်ရှုနိုင်မှာဖြစ်ပါတယ်။ တရားတော်များ မူအရေအတွက်များပြားခြင်းကြောင့် Server ပေါ်တွင်သာ သိမ်းဆည်းထားပါသည်ထို့ကြောင့် တရားတော်များ နာကြားခြင်းများအတွက် Internet Connection ဖွင့်ထားရန်လိုအပ်ပါသည်။ Server မှ  data အသစ်များကိုရယူရန်အတွက် Search Icon ဘေးနားက update icon ကိုနှိပ်ပြီး ရယူနိုင်ပါသည်။";



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: Color.fromRGBO(0, 0, 0, 1)
          ),
          title: Text(_title, style: TextStyle(color: Colors.black),),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed("/home");
            },
            icon: Icon(Icons.arrow_back),
          ),


        ),

        body: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(_readMeBody)
        ),

      ),
    );
  }
}