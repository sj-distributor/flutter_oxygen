import 'package:flutter/material.dart';

import '../baseInkWell/base_ink_well.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.type = "primary",
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    return BaseInkWell(
      child: IconButton(
        icon: Icon(Icons.thumb_up),
        onPressed: () {},
      ),
    );
  }
}
