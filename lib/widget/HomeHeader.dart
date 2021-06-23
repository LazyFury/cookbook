import 'dart:ui';

import 'package:cookbook/pages/search.dart';
import 'package:cookbook/widget/safeArea.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double searchIconOpacity;
  HomeHeader({Key? key, required this.title, required this.searchIconOpacity})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          safeAreaTop(context),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                Opacity(
                  opacity: searchIconOpacity,
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchPage()));
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(300, 60);
}

class MyClipper extends CustomClipper<Path> {
  double height = 0.8;

  MyClipper({double? height}) : height = height ?? 0.8;

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * height);
    double xcenter = size.width * .5;
    double ycenter = size.height;

    path.quadraticBezierTo(xcenter, ycenter, size.width, size.height * height);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
