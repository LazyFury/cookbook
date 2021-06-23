import 'dart:convert';

import 'package:cookbook/model/catesModel.dart';
import 'package:cookbook/pages/list.dart';
import 'package:cookbook/pages/search.dart';
import 'package:cookbook/widget/HomeHeader.dart';
import 'package:cookbook/widget/SingleChildSliver.dart';
import 'package:cookbook/widget/safeArea.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<FirstCate> cates = [];
  bool isHeaderAppBarHide = false;
  ScrollController controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    Api.cate().then((value) {
      var result = Result.form(json.decode(value.data));
      if (result.ok) {
        List<FirstCate> list = (result.result as List<dynamic>)
            .map((e) => FirstCate.form(e))
            .toList();
        setState(() {
          cates = list;
        });
      }
    }).catchError((err) {
      throw err;
    });
    controller.addListener(() {
      setState(() {
        offset = controller.offset;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // header 内容的高度
    double height = 140;
    // 占位的高度
    double boxHeight = height - offset;
    // 不小于0 不大于180
    boxHeight = boxHeight < 0 ? 0 : boxHeight;
    boxHeight = boxHeight > height + 20 ? height + 20 : boxHeight;

    // 透明度
    var opacity = boxHeight / height;
    // 去反 透明度
    var searchIconOpacity = (height - boxHeight) / height;

    // 偏移
    double headerOffsetY = boxHeight - height;
    headerOffsetY = headerOffsetY <= 0 ? headerOffsetY : 0;

    double getOpacity(val) {
      return val <= 1 ? (val >= 0 ? val : 0) : 1;
    }

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: HomeHeader(
          title: widget.title,
          searchIconOpacity: getOpacity(searchIconOpacity),
        ),
        body: Column(
          children: [
            Opacity(
                opacity: getOpacity(opacity),
                child: Transform.translate(
                  offset: Offset(0, headerOffsetY / 2),
                  child: Container(
                    height: boxHeight,
                    child: HeaderAppBar(),
                  ),
                )),
            Expanded(
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SingleChildSliver(
                      child: Container(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: menus
                          .map((e) => WarpMenuItem(
                                cate: e,
                              ))
                          .toList(),
                    ),
                  )),
                  SliverList(
                      delegate: SliverChildListDelegate(cates.reversed
                          .map((e) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CateTitleWidget(
                                      title: e.name,
                                    ),
                                    Container(
                                        child: Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: e.list
                                          .map((sec) => Container(
                                                child: GestureDetector(
                                                  child: Text(sec.name + "、"),
                                                  onTap: () {
                                                    toList(context, sec);
                                                  },
                                                ),
                                              ))
                                          .toList(),
                                    ))
                                  ],
                                ),
                              ))
                          .toList())),
                  SingleChildSliver(child: safeAreaBottom(context))
                ],
              ),
            ),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

toList(BuildContext context, SecCate cate) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ListPage(
            cate: cate,
          )));
}

class WarpMenuItem extends StatelessWidget {
  final SecCate cate;
  const WarpMenuItem({Key? key, required this.cate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        toList(context, cate);
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 60) / 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                cate.icon.isEmpty
                    ? "assets/images/menu/default.jpeg"
                    : cate.icon,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              this.cate.name,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderAppBar extends StatelessWidget {
  const HeaderAppBar({
    Key? key,
  }) : super(key: key);

  toSearch(
    BuildContext context, {
    String? keyword,
  }) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return keyword == null
          ? SearchPage(
              keyword: keyword,
            )
          : SearchListPage(
              keyword: keyword,
            );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: MyClipper(height: .85),
            child: Opacity(
              opacity: .6,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                      Colors.blue,
                      Colors.lightBlue.shade400,
                      Colors.blueAccent
                    ])),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: MyClipper(height: .75),
            child: Opacity(
              opacity: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                      Colors.blue,
                      Colors.lightBlue.shade400,
                      Colors.blueAccent
                    ])),
              ),
            ),
          ),
        ),
        Positioned(
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              child: Column(
                children: [
                  constraints.biggest.height > 100
                      ? InkWell(
                          onTap: () => toSearch(context),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 8,
                                      offset: Offset(0, 6),
                                      color: Colors.black.withOpacity(.1))
                                ],
                                borderRadius: BorderRadius.circular(90)),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  child: Icon(Icons.search),
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                ),
                                Text("点击搜索菜谱~"),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  constraints.biggest.height > 50
                      ? Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: double.infinity,
                          child: Wrap(children: [
                            ...["回锅肉", "家常", "健脾开胃", "炒", "白肉", "鱼"]
                                .map((e) => InkWell(
                                      onTap: () =>
                                          toSearch(context, keyword: e),
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        margin: EdgeInsets.only(
                                            right: 4, bottom: 6),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(.3)),
                                        child: Text(
                                          e,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ]),
                        )
                      : Container(),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}

class CateTitleWidget extends StatelessWidget {
  final String title;
  const CateTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 24,
            margin: EdgeInsets.only(right: 6, bottom: 2),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
