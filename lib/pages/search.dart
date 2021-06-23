import 'dart:convert';

import 'package:cookbook/model/bookModel.dart';
import 'package:cookbook/pages/detail.dart';
import 'package:cookbook/pages/list.dart';
import 'package:cookbook/utils.dart';
import 'package:cookbook/widget/SingleChildSliver.dart';
import 'package:cookbook/widget/safeArea.dart';
import 'package:cookbook/widget/split.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  final String? keyword;
  SearchPage({Key? key, this.keyword}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String keyword = "";
  List<String> rec = ["回锅肉", "家常", "健脾开胃", "炒", "白肉", "鱼"];
  List<String> history = [];
  HistoryPrefs historyPrefs = HistoryPrefs();
  toSearch(BuildContext context, String key) async {
    await historyPrefs.add(key);
    await Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (context, an1, an2) {
      return FadeTransition(
        opacity: an1,
        child: SearchListPage(
          keyword: key,
        ),
      );
    }));

    setState(() {
      keyword = "";
    });
    updateHistory();
  }

  updateHistory() async {
    var _history = await historyPrefs.all;
    setState(() {
      history = _history;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      setState(() {
        keyword = widget.keyword!;
      });
    }

    updateHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchNavBar(
        keyword: keyword,
        onConfirm: (val) {
          toSearch(context, val);
        },
      ),
      body: CustomScrollView(
        slivers: [
          SingleChildSliver(
              child: Column(
            children: [
              _titlebar("热门搜索"),
              SplitWidget(),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Wrap(
                  children: rec
                      .map((e) => InkWell(
                            onTap: () {
                              toSearch(context, e);
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              margin: EdgeInsets.only(right: 4, bottom: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue.withOpacity(.1)),
                              child: Text(
                                e,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              spacer(),
              _titlebar("历史记录",
                  icon: InkWell(
                      onTap: () async {
                        await historyPrefs.clear();
                        updateHistory();
                      },
                      child: Icon(Icons.delete_outline))),
              SplitWidget(),
              Container(
                child: Column(
                    children: history.reversed
                        .map((e) => Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            toSearch(context, e);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(e)))),
                                  InkWell(
                                    child: Icon(Icons.clear_rounded),
                                    onTap: () async {
                                      await historyPrefs
                                          .removeAt(history.indexOf(e));
                                      updateHistory();
                                    },
                                  )
                                ],
                              ),
                            ))
                        .toList()),
              )
            ],
          ))
        ],
      ),
    );
  }
}

class HistoryPrefs {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String _historyStorageKey = "search_history";

  Future<List<String>> get all async {
    var _prefs = await prefs;
    return _prefs.getStringList(_historyStorageKey) ?? [];
  }

  add(String val) async {
    var _prefs = await prefs;
    var list = await this.all;
    var index = list.indexOf(val);
    if (index > -1) {
      list.removeAt(index);
    }
    list.add(val);
    return _prefs.setStringList(_historyStorageKey, list);
  }

  clear() async {
    var _prefs = await prefs;
    return _prefs.remove(_historyStorageKey);
  }

  removeAt(int index) async {
    var _prefs = await prefs;
    var list = await this.all;
    list.removeAt(index);
    return _prefs.setStringList(_historyStorageKey, list);
  }
}

Widget _titlebar(String title, {Widget? icon}) {
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        icon ?? Container()
      ],
    ),
  );
}

class SearchListPage extends StatefulWidget {
  final String? keyword;
  SearchListPage({Key? key, this.keyword}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SearchListPageState();
}

class SearchListPageState extends State<SearchListPage> {
  String keyword = "";
  bool isLoading = false;
  HistoryPrefs historyPrefs = HistoryPrefs();

  List<BookModel> books = [];

  loadAPI({bool reset = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      if (reset) {
        books = [];
      }
    });
    await Api.search(keyword, start: books.length).then((value) {
      var _json = json.decode(value.data);
      print(_json);
      var result = Result.form(_json);
      print(result);
      if (result.ok) {
        List<BookModel> _books =
            ((result.result as Map<String, dynamic>)["list"] as List<dynamic>)
                .map((e) => BookModel.form(e))
                .toList();
        setState(() {
          books.addAll(_books);
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      setState(() {
        keyword = widget.keyword!;
        loadAPI(reset: true);
      });
      (() async {
        await historyPrefs.add(keyword);
      })();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchNavBar(
        keyword: keyword,
        onClear: () {
          Navigator.of(context).pop();
        },
        onConfirm: (val) {
          setState(() {
            keyword = val;
            loadAPI(reset: true);
          });
        },
      ),
      body: GestureDetector(
        onTapDown: (tap) => FocusScope.of(context).requestFocus(FocusNode()),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent) {
              print("load more");
              loadAPI();
            }
            return true;
          },
          child: CustomScrollView(
            slivers: [
              // SingleChildSliver(
              //     child: Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //   decoration: BoxDecoration(color: Colors.grey.shade200),
              //   child: Row(
              //     children: [
              //       Text("关键词："),
              //       Text(keyword),
              //     ],
              //   ),
              // )),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                return FoodBookView(book: books[i]);
              }, childCount: books.length))
            ],
          ),
        ),
      ),
    );
  }
}

class SearchNavBar extends StatefulWidget implements PreferredSizeWidget {
  final String keyword;
  final void Function(String)? onChange;
  final void Function(String)? onConfirm;
  final void Function()? onClear;
  SearchNavBar(
      {Key? key,
      required this.keyword,
      this.onChange,
      this.onConfirm,
      this.onClear})
      : super(key: key);

  @override
  _SearchNavBarState createState() => _SearchNavBarState();

  @override
  Size get preferredSize => Size(300, 54);
}

class _SearchNavBarState extends State<SearchNavBar> {
  TextEditingController textEditingController = TextEditingController();
  String keyword = "";

  @override
  void initState() {
    updateKeyword(widget.keyword);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchNavBar oldWidget) {
    updateKeyword(widget.keyword);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  updateKeyword(String key) {
    textEditingController.text = key;
    setState(() {
      keyword = key;
    });
  }

  bool get hasVal {
    return keyword.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Column(
          children: [
            safeAreaTop(context),
            Row(
              children: [
                BackButton(
                  color: Colors.white,
                ),
                Expanded(
                    child: Container(
                  height: 36,
                  margin: EdgeInsets.only(
                    right: 10,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(Icons.search),
                        margin: EdgeInsets.only(top: 4),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          child: TextField(
                            controller: textEditingController,
                            onSubmitted: (val) {
                              onConfirm(context, val);
                            },
                            onChanged: (val) {
                              onChange(val);
                            },
                            style: TextStyle(
                              height: 1.6,
                            ),
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "想吃点啥？",
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8)),
                          ),
                        ),
                      ),
                      Container(
                        child: hasVal
                            ? InkWell(
                                onTap: () {
                                  clear();
                                },
                                child: Icon(Icons.close_sharp, size: 18))
                            : Container(),
                      ),
                      InkWell(
                        onTap: () {
                          onConfirm(context, keyword);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 6, right: 6),
                          child: Text(
                            "搜索",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(90)),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clear() {
    if (widget.onClear != null) {
      widget.onClear!();
    }
    updateKeyword("");
  }

  void onChange(String val) {
    if (widget.onChange != null) {
      widget.onChange!(val);
    }

    setState(() {
      keyword = val;
    });
  }

  void onConfirm(BuildContext context, String key) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.onConfirm != null && hasVal) {
      widget.onConfirm!(key);
    }
  }
}
