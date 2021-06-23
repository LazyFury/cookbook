import 'package:flutter/material.dart';

class SingleChildSliver extends StatelessWidget {
  final Widget child;
  const SingleChildSliver({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
      return child;
    }, childCount: 1));
  }
}
