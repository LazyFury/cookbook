import 'package:cookbook/constants.dart';
import 'package:cookbook/pages/Setting.dart';
import 'package:cookbook/pages/collection.dart';
import 'package:cookbook/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.lightBlue,
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.grey.shade600),
          )),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [MyHomePage(title: appName), CollectionPage(), SettingPage()],
        index: _selectIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "收藏"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "更多")
        ],
        onTap: (i) {
          setState(() {
            _selectIndex = i;
          });
        },
      ),
    );
  }
}
