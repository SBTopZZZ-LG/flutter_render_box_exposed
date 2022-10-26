library render_box_exposed;

import 'dart:async';

import 'package:flutter/material.dart';

/// An intermediate (or wrapper) class to access the `RenderBox` exposed by `RenderBoxExposed`.
/// Ensure that the property `isExposed` is `true` before trying to access the `value` of `renderBox`.
///
/// Example Usage:
/// ```
/// final RenderBoxExposer exposer = const RenderBoxExposer();
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
  /// Boolean value representing the state of the `renderBox` property.
  /// Returns `true` if the `RenderBox` is exposed, otherwise `false.
  bool isExposed = false;

  /// A `ValueNotifier` for the `RenderBox` object.
  /// Use `ValueListenableBuilder` to subscribe to the changes to the `RenderBox`.
  ValueNotifier<RenderBox?> renderBox = ValueNotifier(null);
}

/// A widget wrapper class to expose the `RenderBox` of the `child` widget.
///
/// Example Usage:
/// ```
/// final RenderBoxExposer exposer = const RenderBoxExposer();
///
/// @override
/// Widget build(BuildContext build) {
///   return Center(
///     child: Column(
///       children: [
///         RenderBoxExposed(
///           child: Text("Sample text", style: TextStyle(fontSize: 30)),
///           exposer: exposer,
///         ),
///         ValueListenableBuilder(
///           valueListenable: exposer.renderBox,
///           builder: (ctx, renderBox, c) {
///               // To check if `RenderBox` is available, use the `isExposed` property, or alternatively check if `renderBox` is not null
///               return Text("Width: ${exposer.isExposed ? renderBox!.size.width : 0}");
///           }
///         ),
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

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      exposer.isExposed = true;
      exposer.renderBox.value =
          _globalKey.currentContext!.findRenderObject() as RenderBox;
    });

    return Container(
      key: _globalKey,
      child: child,
    );
  }
}
