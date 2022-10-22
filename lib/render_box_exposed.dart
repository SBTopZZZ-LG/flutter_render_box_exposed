library render_box_exposed;

import 'dart:async';

import 'package:flutter/material.dart';

class RenderBoxExposer {
  final void Function(void Function()) updateState;

  RenderBoxExposer({required this.updateState});

  bool isExposed = false;
  RenderBox? renderBox;
}

class RenderBoxExposed extends StatelessWidget {
  final Widget child;
  final RenderBoxExposer exposer;

  RenderBoxExposed({super.key, required this.child, required this.exposer});

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      bool flagFirstBuild = !exposer.isExposed;

      exposer.isExposed = true;
      exposer.renderBox =
          globalKey.currentContext!.findRenderObject() as RenderBox;

      if (flagFirstBuild) {
        exposer.updateState(() => {});
      }
    });

    return Container(
      key: globalKey,
      child: child,
    );
  }
}
