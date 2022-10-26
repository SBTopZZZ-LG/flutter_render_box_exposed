import 'package:flutter/material.dart';
import 'package:render_box_exposed/render_box_exposed.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final RenderBoxExposer textExposer;
  late final AnimationController controller;

  double textSize = 10;

  @override
  void initState() {
    super.initState();

    textExposer = RenderBoxExposer();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    Animation tween = IntTween(begin: 10, end: 35).animate(controller);
    tween.addListener(() => setState(() => textSize = tween.value));

    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: ValueListenableBuilder(
            valueListenable: textExposer.renderBox,
            builder: ((context, value, child) {
              if (value != null) {
                return Text("Height: ${value.size.height}");
              } else {
                return const Text("RenderBoxExposed");
              }
            }),
          ),
          centerTitle: true),
      body: Center(
        child: RenderBoxExposed(
          exposer: textExposer,
          child: Text("Sample text", style: TextStyle(fontSize: textSize)),
        ),
      ),
    );
  }
}
