import 'dart:convert';

import 'package:cookbook/model/bookModel.dart';
import 'package:cookbook/model/catesModel.dart';
import 'package:cookbook/pages/collection.dart';
import 'package:cookbook/pages/detail.dart';
import 'package:cookbook/utils.dart';
import 'package:cookbook/widget/NavBar.dart';
import 'package:cookbook/widget/SingleChildSliver.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final SecCate cate;
  ListPage({Key? key, required this.cate}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  List<BookModel> books = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadAPI();
  }

  loadAPI() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    await Api.cateList(widget.cate.classid, start: books.length).then((value) {
      var result = Result.form(json.decode(value.data));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: widget.cate.name),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent) {
            print("load more");
            loadAPI();
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
              return FoodBookView(book: books[i]);
            }, childCount: books.length)),
            SingleChildSliver(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FoodBookView extends StatefulWidget {
  final BookModel book;
  final Function(bool isCollected)? onChange;
  final Future<void> Function()? afterRouteChanege;
  FoodBookView(
      {Key? key, required this.book, this.onChange, this.afterRouteChanege})
      : super(key: key);

  @override
  _FoodBookViewState createState() => _FoodBookViewState();
}

class _FoodBookViewState extends State<FoodBookView> {
  final CollectionPrefs collectionPrefs = CollectionPrefs();
  bool isCollected = false;

  update() async {
    var _isCollected = await collectionPrefs.isCollect(widget.book);
    setState(() {
      isCollected = _isCollected;
    });
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, animation1) {
                  return new FadeTransition(
                    opacity: animation,
                    child: DetailPage(book: widget.book),
                  );
                }));

                if (widget.afterRouteChanege != null) {
                  await widget.afterRouteChanege!();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: new CoverHero(
                        src: widget.book.pic,
                        width: 120,
                        tag: "cook-book-cover-${widget.book.id}"),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.name,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          "用时：" + widget.book.cookingtime,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          widget.book.content,
                          style: TextStyle(color: Colors.grey.shade400),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Wrap(
                          children: widget.book.tag
                              .split(",")
                              .map((e) => BookTagWidget(
                                    tag: e,
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (isCollected) {
                collectionPrefs.remove(widget.book);
              } else {
                collectionPrefs.add(widget.book);
              }
              setState(() {
                isCollected = !isCollected;
              });
              if (widget.onChange != null) {
                widget.onChange!(isCollected);
              }
            },
            child: Column(
              children: [
                Icon(
                  isCollected ? Icons.star : Icons.star_outline,
                  size: 32,
                  color: Colors.orange,
                ),
                Text(isCollected ? "已收藏" : "收藏")
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BookTagWidget extends StatelessWidget {
  final String tag;
  const BookTagWidget({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6),
      margin: EdgeInsets.only(right: 5, bottom: 5),
      child: Text(
        tag,
        style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
      ),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(.1)),
    );
  }
}
