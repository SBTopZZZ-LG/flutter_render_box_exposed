library render_box_exposed;

import 'dart:async';

import 'package:flutter/material.dart';

/// An intermediate (or wrapper) class to access the `RenderBox` exposed by `RenderBoxExposed`.
/// Ensure that the property `isExposed` is `true` before trying to access the `renderBox`.
///
/// Note: The current build only supports the usage of `StatefulWidget` in order to access the exposed `RenderBox`.
///
/// Example Usage:
/// ```
/// final RenderBoxExposer exposer = RenderBoxExposer(updateState: setState);
///
/// @override
/// Widget build(BuildContext build) {
///   return Center(
///     child: RenderBoxExposed(
///       child: <widget>,
///       exposer: exposer,
///     ),
///   );
/// }
/// ```
class RenderBoxExposer {
  /// A callback function which is called once when the `RenderBox` is exposed
  final void Function(void Function()) updateState;

  RenderBoxExposer({required this.updateState});

  /// Boolean value representing the state of the `renderBox` property.
  /// Returns `true` if the `RenderBox` is exposed, otherwise `false.
  bool isExposed = false;

  /// The exposed `RenderBox`
  RenderBox? renderBox;
}

/// A widget wrapper class to expose the `RenderBox` of the `child` widget.
///
/// Example Usage:
/// ```
/// final RenderBoxExposer exposer = RenderBoxExposer(updateState: setState);
///
/// @override
/// Widget build(BuildContext build) {
///   double width = 0;
///   if (exposer.isExposed) {
///     width = exposer.renderBox!.size.width;
///   }
///
///   return Center(
///     child: Column(
///       children: [
///         RenderBoxExposed(
///           child: Text("Sample text", style: TextStyle(fontSize: 30)),
///           exposer: exposer,
///         ),
///         Text("Width: ${width}"),
///       ],
///     ),
///   );
/// }
/// ```
class RenderBoxExposed extends StatelessWidget {
  /// The child widget whose `RenderBox` is to be exposed
  final Widget child;

  /// The exposer wrapper object through which the exposed `RenderBox` is made accessible
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
