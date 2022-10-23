<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
# render_box_exposed
A flutter package to expose a widget's RenderBox.

## Getting started

Add the package to your Flutter project.
```Yaml
render_box_exposed: ^1.0.0
```

## Properties
**RenderBoxExposer**
```Dart
// `true` if the RenderBox has been exposed, otherwise `false`
bool isExposed;

// The exposed RenderBox
// This value is null before the first build is completed
RenderBox? renderBox;
```

## Usage

Use the `RenderBoxExposed` class to enclose the widget of choice, which will in turn expose the `RenderBox` of that widget.
```Dart
@override
Widget build(BuildContext context) {
    return Center(
        child: RenderBoxExposed(
            exposer: ...,
            child: Text("Hey!"),
        ),
    );
}
```

Finally, use the `RenderBoxExposer` wrapper class to retrieve the `RenderBox` object after the first build.
```Dart
late final RenderBoxExposer exposer;

@override
void initState() {
    exposer = RenderBoxExposer(
        updateState: setState,
    );
}

@override
Widget build(BuildContext context) {
    return Center(
        child: RenderBoxExposed(
            exposer: exposer,
            child: Text("Hey!"),
        ),
    );
}
```

To access the exposed `RenderBox`, use conditional logic to check if the value is available.
```Dart
// BAD (`renderBox` is null during the first build)
double width = exposer.renderBox!.size.width;

// GOOD
if (exposer.isExposed) {
    double width = exposer.renderBox!.size.width;
}
```

Full example.
```Dart
late final RenderBoxExposer exposer;

@override
void initState() {
    exposer = RenderBoxExposer(
        updateState: setState,
    );
}

@override
Widget build(BuildContext context) {
    double width = 0; // has a default value
    if (exposer.isExposed) {
        // fetch actual width here (after first build)
        width = exposer.renderBox!.size.width;
    }

    return Center(
        child: Column(
            children: [
                RenderBoxExposed(
                    exposer: exposer,
                    child: Text("Hey!"),
                ),
                Text("Width: ${width}"),
            ],
        ),
    );
}
```
