import 'package:flutter/material.dart';

import '/app/core/values/text_styles.dart';

class AppBarTitle extends StatelessWidget {
  final String text;

  const AppBarTitle({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: pageTitleStyle,
      textAlign: TextAlign.center,
    );
  }
}
