import 'package:flutter/material.dart';

Widget safeAreaTop(BuildContext context) => SizedBox(
      height: MediaQuery.of(context).padding.top,
    );

Widget safeAreaBottom(BuildContext context) => SizedBox(
      height: MediaQuery.of(context).padding.bottom,
    );
