import 'dart:convert';

import 'package:cookbook/model/bookModel.dart';
import 'package:cookbook/pages/list.dart';
import 'package:cookbook/widget/NavBar.dart';
import 'package:cookbook/widget/SingleChildSliver.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionPage extends StatefulWidget {
  final bool showBackBtn;
  CollectionPage({Key? key, this.showBackBtn = false}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CollectionPageState();
}

class CollectionPageState extends State<CollectionPage> {
  CollectionPrefs collectionPrefs = CollectionPrefs();
  List<BookModel> books = [];
  List<int> hideIds = [];

  Future<void> update() async {
    var _books = await collectionPrefs.all;
    setState(() {
      books = _books;
    });
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  void didUpdateWidget(covariant CollectionPage oldWidget) {
    update();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        title: "收藏",
        showBackBtn: widget.showBackBtn,
      ),
      body: CustomScrollView(
        slivers: [
          SingleChildSliver(
              child: Container(
            child: Column(),
          )),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
            return hideIds.indexOf(books[i].id) <= -1
                ? FoodBookView(
                    book: books[i],
                    onChange: (isCollected) {
                      if (!isCollected) {
                        setState(() {
                          hideIds.add(books[i].id);
                        });
                      }
                    },
                    afterRouteChanege: update,
                  )
                : Container();
          }, childCount: books.length))
        ],
      ),
    );
  }
}

class CollectionPrefs {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String _storageKey = "collection";

  Future<List<String>> get allStrList async {
    var _prefs = await prefs;
    return (_prefs.getStringList(_storageKey) ?? []);
  }

  Future<List<BookModel>> get all async {
    var list = await allStrList;
    return list.reversed.map((e) => BookModel.form(json.decode(e))).toList();
  }

  Future<bool> add(BookModel val) async {
    var _prefs = await prefs;
    var list = await this.allStrList;
    var index = list.indexOf(val.toString());
    if (index > -1) {
      return false;
    }
    list.add(val.toString());
    return _prefs.setStringList(_storageKey, list);
  }

  Future removeAt(int index) async {
    var _prefs = await prefs;
    var list = await this.allStrList;
    list.removeAt(index);
    return _prefs.setStringList(_storageKey, list);
  }

  Future remove(BookModel book) async {
    var list = await this.allStrList;
    var index = list.indexOf(book.toString());
    if (index <= -1) return;
    return removeAt(index);
  }

  Future<bool> isCollect(BookModel val) async {
    var list = await this.allStrList;
    var index = list.indexOf(val.toString());
    return index > -1;
  }
}
