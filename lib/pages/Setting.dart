import 'package:cookbook/utils.dart';
import 'package:cookbook/widget/HomeHeader.dart';
import 'package:cookbook/widget/NavBar.dart';
import 'package:cookbook/widget/split.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  final BannerAd bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: "ca-app-pub-7365907728205811/2071343303",
      listener: BannerAdListener(),
      request: AdRequest());

  late Widget adWidget;
  @override
  void initState() {
    bannerAd.load();
    adWidget = AdWidget(ad: bannerAd);
    super.initState();
  }

  @override
  void dispose() {
    adWidget = Container();
    bannerAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        title: "",
        showBackBtn: false,
      ),
      body: Container(
          child: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: MyClipper(height: .8),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.blue,
                            Colors.lightBlue.shade400,
                            Colors.blueAccent
                          ])),
                  child: SvgPicture.asset(
                    "assets/images/meeting.svg",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: adWidget,
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
          ),
          item("关于我们", onTap: () => launchUrl("https://github.com/lazyfury")),
          SplitWidget(),
          item("领取购物优惠券",
              color: Colors.red,
              onTap: () => launchUrl("https://tao.abadboy.cn")),
          SplitWidget(),
          Text("©Copyright 2021~2022"),
        ],
      )),
    );
  }

  Widget item(String title, {Function()? onTap, Color color = Colors.black54}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: color),
        ),
      ),
    );
  }
}
