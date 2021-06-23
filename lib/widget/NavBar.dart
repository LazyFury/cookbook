import 'package:cookbook/widget/safeArea.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackBtn;
  final Widget? btn;
  const NavBar(
      {Key? key, required this.title, this.showBackBtn = true, this.btn})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showBackBtn
                  ? BackButton(
                      color: Colors.white,
                    )
                  : Container(
                      height: 54,
                      margin: EdgeInsets.only(left: 10, right: 10),
                    ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: btn ?? Container(),
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(300, 54);
}
