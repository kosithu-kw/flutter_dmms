import 'dart:io';

import 'package:dmms/sayardaw.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ConfirmExit extends StatefulWidget {
  const ConfirmExit({Key? key}) : super(key: key);

  @override
  _ConfirmExitState createState() => _ConfirmExitState();
}

class _ConfirmExitState extends State<ConfirmExit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Stack(
            children: [

             Center(
               child:  Container(
                 child: Image.asset("assets/images/logo.png", width: 120,),
               ),
             ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [



                      TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, PageTransition(child: Sayardaw(), type: PageTransitionType.rightToLeft));

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_fill, color: Colors.black,),
                              SizedBox(width: 5,),
                              Text("တရားတော်များနားဆင်မည်",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                            ],
                          )
                      ),
                      SizedBox(height: 20,),
                      TextButton(
                          onPressed: (){
                            exit(0);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.exit_to_app, color: Colors.black,),
                              SizedBox(width: 5,),
                              Text("ထွက်မည်", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                            ],
                          )
                      ),
                    ],
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
