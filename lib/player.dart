// This is a minimal example demonstrating a play/pause button and a seek bar.
// More advanced examples demonstrating other features can be found in the same
// directory as this example in the GitHub repository.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmms/sayardaw.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'common.dart';
import 'package:rxdart/rxdart.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class MyPlayer extends StatefulWidget {
  final data;
  const MyPlayer({Key? key, required this.data}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyPlayer> {

/*
  String InterstitialId="";
  bool showInter=false;

  _getAdId() async{
    var result=await http.get(Uri.https("raw.githubusercontent.com", "kosithu-kw/dmms_data/master/ads.json"));
    var jsonData=await jsonDecode(result.body);
    //print(jsonData['int']);

      if(jsonData['showInter']=="true"){
        setState(() {
          InterstitialId=jsonData['int'];
          showInter=true;
          if(!_isInterstitialAdReady){
            _loadInterstitialAd();
          }

        });
      }else{
        setState(() {
          showInter=false;
        });
      }

  }

 */

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


  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Sayardaw()));
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }


  bool _isConnected=true;
  bool _isLoading=false;
  String _tryText= "အင်တာနက်ဆက်သွယ်မှုများပြတ်တောက်နေပါသည်";


  final AudioPlayer _player = AudioPlayer();


  @override
  void initState() {
    super.initState();

    if(!_isBannerAdReady){
      _callBannerAds();
    }

    if(!_isInterstitialAdReady){
      _loadInterstitialAd();
    }
   // _getAdId();


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();

    _player.play();
  }


  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
          "${widget.data['d_url']}")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _interstitialAd?.dispose();
    _bannerAd.dispose();
    _player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       /* floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_isInterstitialAdReady){
              _interstitialAd?.show();
              _player.stop();
            }else{
              _player.stop();
              Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeft, child: Sayardaw()));
            }
          },
          child: Icon(Icons.home, color: Colors.black,),
          backgroundColor: Colors.white70,
        ),

        */
        body: SafeArea(
          child: Stack(
            children: [
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
              Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 60),
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellowAccent.withOpacity(0.3),
                            spreadRadius: 20,
                            blurRadius: 20,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: "${widget.data['s_image']}",
                          //height: 50,
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
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Text("${widget.data['s_name']}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(widget.data['d_title'],
                        textAlign: TextAlign.center,
                      ),
                    )
                    ),
                  ),
                  // Display play/pause button and volume/speed sliders.
                 // ControlButtons(_player),
                  // Display seek bar. Using StreamBuilder, this widget rebuilds
                  // each time the position, buffered position or duration changes.
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: _player.seek,
                      );
                    },
                  ),
                  SizedBox(height: 20,),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),

                      child:Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.black, size: 25,)
                        ),
                        ControlButtons(_player),
                        IconButton(
                            onPressed: (){
                              if(_isInterstitialAdReady){
                                _interstitialAd?.show();
                                _player.stop();
                              }else{
                                _player.stop();
                                Navigator.of(context).push(PageTransition(type: PageTransitionType.rightToLeft, child: Sayardaw()));
                              }
                            },
                            icon: Icon(Icons.home, color: Colors.black, size: 25,)
                        )
                      ],
                    ),
                    )
                  ),

                ],
              ),
             /* Container(
                margin: EdgeInsets.only(left: 20, bottom: 15),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 5, color: Color.fromRGBO(212, 213, 214, .8), spreadRadius: 3)],
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Icon(Icons.arrow_back, color: Colors.black, size: 25,),
                      ),
                    )
                  )
                ),
              )

              */
            ],
          )
        ),
      ),

    );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  backgroundColor: Colors.black,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],

    );
  }
}