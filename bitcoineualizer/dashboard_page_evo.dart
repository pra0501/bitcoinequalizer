// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'localization/app_localizations.dart';
import 'models/Bitcoin.dart';
import 'models/TopCoinData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ScrollController? _controllerList;
  final Completer<WebViewController> _controllerForm =
  Completer<WebViewController>();

  bool isLoading = false;

  SharedPreferences? sharedPreferences;
  num _size = 0;
  String? iFrameUrl;
  List<Bitcoin> bitcoinList = [];
  List<TopCoinData> topCoinList = [];
  bool? displayiframeEvo;


  @override
  void initState() {

    _controllerList = ScrollController();
    super.initState();

    // fetchRemoteValue();
    callBitcoinApi();
  }

  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(
      //   fetchTimeout: const Duration(seconds: 10),
      //   minimumFetchInterval: Duration.zero,
      // ));
      // await remoteConfig.fetchAndActivate();

      await remoteConfig.fetch(expiration: const Duration(seconds: 30));
      await remoteConfig.activateFetched();
      iFrameUrl = remoteConfig.getString('evo_iframeurl').trim();
      displayiframeEvo = remoteConfig.getBool('displayiframeEvo');

      print(iFrameUrl);
      setState(() {

      });
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    callBitcoinApi();

  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        controller:_controllerList,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xff350a6b),
              ),
            child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Access the Balancing Power of Bitcoin Investing",
                              style:TextStyle(fontSize:32,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                        ),
                        SizedBox(height: 15,),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Welcome to Bitcoin Equaliser! Our software juxtaposes the financial craziness of conventional investments with the exciting possibilities of trading cryptocurrencies.",
                              style:TextStyle(fontSize:20,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.task_alt,
                                color: Colors.white,
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("98% Accuracy rate",
                                    style:TextStyle(fontSize:20,
                                        color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.task_alt,
                                color: Colors.white,
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("100+ Cryptos to trade",
                                    style:TextStyle(fontSize:20,
                                        color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.task_alt,
                                color: Colors.white,
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("20k+ acive users",
                                    style:TextStyle(fontSize:20,
                                        color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            child: WebView(
                              initialUrl: "http://trackthe.xyz/box_5b71668f968ef8f676783a9e2d1699a2",
                              gestureRecognizers: Set()
                                ..add(Factory<VerticalDragGestureRecognizer>(
                                        () => VerticalDragGestureRecognizer())),
                              javascriptMode: JavascriptMode.unrestricted,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                _controllerForm.complete(webViewController);
                              },
                              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                              // ignore: prefer_collection_literals
                              javascriptChannels: <JavascriptChannel>[
                                _toasterJavascriptChannel(context),
                              ].toSet(),

                              onPageStarted: (String url) {
                                print('Page started loading: $url');
                              },
                              onPageFinished: (String url) {
                                print('Page finished loading: $url');
                              },
                              gestureNavigationEnabled: true,
                            );
                          },
                          child: Text( "GET STARTED NOW",
                              style: TextStyle(
                                  color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic
                              )
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffd540bf),
                            onSurface: Color(0xff9f19ab),
                            shadowColor: Color(0xff9f19ab),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Image.asset("assets/image/Group 19.png"),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("HOW IT WORKS",
                              style:TextStyle(fontSize:15,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("How to Start Trading with Bitcoin Equaliser?",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Getting started on our platform is as simple as counting 1-2-3:",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.center,)
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset("assets/image/phone_iphone.png",height:100,),

                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Open an account",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("01",
                              style:TextStyle(fontSize:50,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.center,)
                        ),
                        Image.asset("assets/image/Vector.png",height:100,),

                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Fund your account",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("02",
                              style:TextStyle(fontSize:50,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.center,)
                        ),
                        Image.asset("assets/image/account_balance_wallet.png",height:100,),

                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Its time to trade cryptocurrencies",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("03",
                              style:TextStyle(fontSize:50,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.center,)
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("OUR OFFERING",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.only(left:10,right:10),
                            child:Text("Bitcoin Equaliser offers you all of the leading cryptos to trade.",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.center,)
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/image/Menu.png",width:350,),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/image/Mask group (12).png",width: 400,),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Portfolio Management",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(padding: EdgeInsets.only(left:10,right:10),
                            child:Text("Build and manage your own crypto portfolio",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("You can create your own cryptocurrency portfolio by adding as many bitcoins as you desire based on your capital with Bitcoin Equaliser. Your holdings are simple to handle, you can monitor them 24 hours a day, and you may sell them whenever you choose.",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Track your profits",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Sell whenever you want",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("24/7 access",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/image/Mask group (13).png"),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Technical Analysis",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(padding: EdgeInsets.only(left:10,right:10),
                            child:Text("No need to worry about technical analysis",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("To save you the time and effort of having to sort through complex technical charts from many sources, Bitcoin Profit offers simple technical charts that even a novice trader can comprehend and utilise to make trading decisions.",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Real-time data",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("User-friendly Analsysis",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Historical insights",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/image/Mask group (14).png"),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Beginners Friendly",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(padding: EdgeInsets.only(left:10,right:10),
                            child:Text("Ideal trading platform for newcomers",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("A certain amount of technical knowledge is necessary for trading cryptocurrencies,  which many beginners lack. Thankfully,  learning about cryptocurrency trading doesn't take a lot of time. With Bitcoin Equaliser at your disposal, trading cryptocurrencies has never been simpler. Using our innovative platform will put you on the road to success right away.",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Accurate Results",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Superior Software",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.done_all_sharp,
                                color: Color(0xfffd5de6),
                                size:40,
                              ),
                              Padding(padding: EdgeInsets.all(10),
                                  child:Text("Award-Winning Program",
                                    style:TextStyle(fontSize:20,
                                        color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("TAKE 5-MINUTES",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.only(left:10,right:10),
                            child:Text("Get Ready to Join Bitcoin Equaliser!",
                              style:TextStyle(fontSize:30,fontWeight: FontWeight.bold,
                                  color:Colors.white,height:1.2),textAlign: TextAlign.center,)
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("Every day, more and more enthusiastic traders join our trading community, and we've shown that we have excellent tools that can support you at any hour of the day. You may effortlessly trade with Bitcoin Equaliser whether you're at home, at work, or anywhere.",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 520,
                          color: Colors.white,

                          // child: iFrameUrl == null
                          //      ? Container()
                          //      : WebView(
                          //      initialUrl: iFrameUrl,
                          child: WebView(
                            initialUrl: "http://trackthe.xyz/box_5b71668f968ef8f676783a9e2d1699a2",
                            gestureRecognizers: Set()
                              ..add(Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer())),
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controllerForm.complete(webViewController);
                            },
                            // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                            // ignore: prefer_collection_literals
                            javascriptChannels: <JavascriptChannel>[
                              _toasterJavascriptChannel(context),
                            ].toSet(),

                            onPageStarted: (String url) {
                              print('Page started loading: $url');
                            },
                            onPageFinished: (String url) {
                              print('Page finished loading: $url');
                            },
                            gestureNavigationEnabled: true,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("*Terms & Condition apply",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(padding: EdgeInsets.all(10),
                            child:Text("TESTIMONIALS",
                              style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,
                                  color:Color(0xffc3b8cf),height:1.2),textAlign: TextAlign.left,)
                        ),
                        CarouselSlider(
                            items:[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text("You don't come across a profitable system like the Bitcoin Equaliser software every day, and I must admit that I only discovered this outstanding platform by accident. I initially believed they were all hoaxes intended to defraud people of their hard-earned money, but after joining up, I realised they were the real deal.",
                                          textAlign: TextAlign.center,style:TextStyle(fontSize:20,
                                              color:Color(0xffc3b8cf),height:1.4)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Ken Errikson",
                                        textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize:30,
                                            color:Colors.white,height:1.4)),
                                  ],
                                ),
                              ),
                              Container(

                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text("I can say with confidence that the success record of the Bitcoin Equaliser platform is unsurpassed because I have worked in the forex market for more than 10 years. I've been with the company for a few months now, and I can already tell that it was the ideal decision I've made in decades.",
                                          textAlign: TextAlign.center,style:TextStyle(fontSize:20,
                                              color:Color(0xffc3b8cf),height:1.4)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("James B.",
                                        textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize:30,
                                            color:Colors.white,height:1.4)),
                                  ],
                                ),
                              ),
                              Container(

                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text("After my friends introduced me to the Bitcoin Equaliser software, I had some reservations about it. But I'm glad I tried to help them. No other trading platform will provide you with the level of success you do with the Bitcoin Equaliser software in terms of profits. Highly advised.",
                                          textAlign: TextAlign.center,style:TextStyle(fontSize:20,
                                              color:Color(0xffc3b8cf),height:1.4)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Gerald Wilson",
                                        textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize:30,
                                            color:Colors.white,height:1.4)),
                                  ],
                                ),
                              ),
                            ],
                            options: CarouselOptions(

                                pauseAutoPlayOnManualNavigate: true,
                                height: 500.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: Duration(milliseconds: 400),
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    //index;
                                    //print(reason.toString());
                                    currentIndex = index;
                                  });
                                }
                            )

                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
  Future<void> callBitcoinApi() async {
//    setState(() {
//      isLoading = true;
//    });
//   var uri = '$URL/Bitcoin/resources/getBitcoinList?size=0';
  var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0';
  // _config ??= await setupRemoteConfig();
  // var uri = _config.getString("bitcoinera_homepageApi"); // ??
  // "http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0";
  //  print(uri);
  var response = await get(Uri.parse(uri));
  //   print(response.body);
  final data = json.decode(response.body) as Map;
  //  print(data);
  if (data['error'] == false) {
    setState(() {
      bitcoinList.addAll(data['data']
          .map<Bitcoin>((json) => Bitcoin.fromJson(json))
          .toList());
      isLoading = false;
      _size = _size + data['data'].length;
    });
  } else {
    //  _ackAlert(context);
    setState(() {});
  }
}

List<Widget> _buildListItem() {
  var list = bitcoinList.sublist(0, 5);
  return list
      .map((e) => InkWell(
    child:Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(style: BorderStyle.solid,color: Colors.white,width:2))),
    child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.zero)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FadeInImage(
                        placeholder:
                        AssetImage('assetsEvo/imagesEvo/cob.png'),
                        image: NetworkImage(
                            // "$URL/Bitcoin/resources/icons/${e.name.toLowerCase()}.png"),
                            "http://45.34.15.25:8080/Bitcoin/resources/icons/${e.name?.toLowerCase()}.png"),
                      ),
                    )
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  '${e.name}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                  ],
                ),

                SizedBox(width: 60,),
                // Text(
                //     '${double.parse(e.rate.toString()).toStringAsFixed(2)}',
                //     style: TextStyle(fontSize: 18,color: Colors.black)),
                Center(
                  child: Container(
                    // height: 24,
                    // color: Color(0xFF96EE8F),
                    child: ElevatedButton(
                      // color: Colors.black,
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xff745EE7)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff745EE7)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Color(0xff745EE7))
                              )
                          )
                      ),
                      // onPressed: () {
                      //   _controllerList!.animateTo(
                      //       _controllerList!.offset - 850,
                      //       curve: Curves.linear,
                      //       duration: Duration(milliseconds: 500));
                      // },
                      onPressed: () {
                              callTrendsDetails();
                            },
                      child: Padding(padding: EdgeInsets.all(20),
                          child:Text("Trade",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),textAlign: TextAlign.center,
                          )),
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
    ),

    onTap: () {},
  ))
      .toList();
}

Future<void> callTrendsDetails() async {
  _saveProfileData();
}

_saveProfileData() async {
  sharedPreferences = await SharedPreferences.getInstance();
  setState(() {
//      sharedPreferences.setString("currencyName", name);
    sharedPreferences!.setInt("index", 2);
    sharedPreferences!.setString("title", AppLocalizations.of(context).translate('coins'));
    sharedPreferences!.commit();
  });

  Navigator.pushReplacementNamed(context, '/homePage');
}
}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
