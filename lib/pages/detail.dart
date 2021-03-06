import 'package:cookbook/model/bookModel.dart';
import 'package:cookbook/pages/collection.dart';
import 'package:cookbook/pages/list.dart';
import 'package:cookbook/widget/NavBar.dart';
import 'package:cookbook/widget/SingleChildSliver.dart';
import 'package:cookbook/widget/safeArea.dart';
import 'package:cookbook/widget/split.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DetailPage extends StatefulWidget {
  final BookModel book;

  DetailPage({Key? key, required this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  BookModel get book {
    return widget.book;
  }

  GlobalKey materialKey = GlobalKey();
  GlobalKey progressKey = GlobalKey();
  GlobalKey topKey = GlobalKey();
  bool isCollected = false;
  CollectionPrefs collectionPrefs = CollectionPrefs();

  update() async {
    var _isCollected = await collectionPrefs.isCollect(widget.book);
    setState(() {
      isCollected = _isCollected;
    });
  }

  @override
  void initState() {
    update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: NavBar(
        title: book.name,
        btn: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return CollectionPage(
                showBackBtn: true,
              );
            }));
          },
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 6),
                child: Text(
                  "ζηζΆθ",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Icon(
                Icons.star,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SingleChildSliver(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CoverHero(
                        key: topKey,
                        src: book.pic,
                        width: width,
                        tag: "cook-book-cover-${book.id}",
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "εΆδ½ζΆι΄οΌ" + book.preparetime,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              SplitWidget(),
                              Text(book.content),
                              SplitWidget(),
                              Wrap(
                                children: book.tag
                                    .split(",")
                                    .map((e) => BookTagWidget(tag: e))
                                    .toList(),
                              )
                            ],
                          )),
                      spacer(),
                      MaterialWidget(
                        book: book,
                        key: materialKey,
                      ),
                      spacer(),
                      ProgressWidget(
                        book: book,
                        key: progressKey,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionWidget(
                      label: "εε°ι‘Άι¨",
                      icon: Icons.arrow_upward,
                      onTap: scrollTo(topKey),
                      context: context),
                  actionWidget(
                      label: "ζ₯ηιζ",
                      icon: Icons.file_present,
                      onTap: scrollTo(materialKey),
                      context: context),
                  actionWidget(
                      label: "εΆδ½ζ΅η¨",
                      icon: Icons.map_outlined,
                      onTap: scrollTo(progressKey),
                      context: context),
                  actionWidget(
                      label: isCollected ? "ε·²ζΆθ" : "ζΆθθθ°±",
                      icon: isCollected ? Icons.star : Icons.star_outline,
                      onTap: () {
                        if (isCollected) {
                          collectionPrefs.remove(book);
                        } else {
                          collectionPrefs.add(book);
                        }

                        setState(() {
                          isCollected = !isCollected;
                        });
                      },
                      context: context),
                ],
              ),
              safeAreaBottom(context)
            ],
          ))
        ],
      ),
    );
  }

  scrollTo(GlobalKey key) => () => Scrollable.ensureVisible(key.currentContext!,
      curve: Curves.easeIn, duration: Duration(milliseconds: 300));

  InkWell actionWidget(
      {required String label,
      required IconData icon,
      required Function() onTap,
      required BuildContext context}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(6),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            Text(label),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

class CoverHero extends StatelessWidget {
  final double width;
  final String src;
  final GestureTapCallback? onTap;
  final String tag;
  CoverHero(
      {Key? key,
      required this.src,
      this.width = 80,
      this.onTap,
      required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: new Hero(
          tag: Key(this.tag),
          child: Material(
            child: InkWell(
              onTap: onTap,
              child: Image.network(
                src,
                width: width,
                height: width,
                fit: BoxFit.cover,
              ),
            ),
          )),
    );
  }
}

class ProgressWidget extends StatelessWidget {
  final BookModel book;
  ProgressWidget({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          title("εΆδ½ζ­₯ιͺ€", context),
          Column(
            children: book.process.map((e) {
              int i = book.process.indexOf(e);
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Image.network(e.pic,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            e.pcontent,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: Text(
                          "η¬¬${i + 1} ζ­₯",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      left: 0,
                      top: 20,
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

Widget spacer() {
  return Container(
    height: 10,
    decoration: BoxDecoration(color: Colors.grey.shade100),
  );
}

Widget title(String title, BuildContext context) {
  return Container(
    padding: EdgeInsets.all(10),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
        ),
        Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        // SplitWidget()
      ],
    ),
  );
}

class MaterialWidget extends StatelessWidget {
  final BookModel book;
  MaterialWidget({Key? key, required this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          title("ιζθ‘¨", context),
          Column(
            children: book.material.map((e) => materialItemWidget(e)).toList(),
          )
        ],
      ),
    );
  }
}

Widget materialItemWidget(MaterialModel material) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(["θ°ζ", "ιθ"][material.type]),
        Container(
          child: Text(
            material.mname,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          width: 200,
          margin: EdgeInsets.only(left: 10),
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          material.amount,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    ),
  );
}
