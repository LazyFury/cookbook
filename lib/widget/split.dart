import 'package:flutter/material.dart';

class SplitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: Colors.grey.shade100),
    );
  }
}
