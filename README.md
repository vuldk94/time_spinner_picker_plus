# Time Spinner Picker Plus

A beautiful and animated time picker spinner

[![pub](https://img.shields.io/pub/v/time_spinner_picker_plus.svg)](https://pub.dev/packages/time_spinner_picker_plus)
[![license: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful and animated time picker spinner

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  time_spinner_picker_plus: [latest]
```

## Features

A beautiful and animated time picker spinner

## Getting started

This project is a starting point for a Dart package, a library module containing code that can be shared easily across multiple Flutter or Dart projects.

For help getting started with Flutter, view our online documentation, which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Props
| props           |    types     |          defaultValues          |
|:----------------|:------------:|:-------------------------------:|
| initialTime     |   DateTime   | Current Time [ DateTime.now() ] |
| minutesInterval |     int      |                1                |
| secondsInterval |     int      |                1                |
| is24h           |     bool     |              true               |
| isShowSeconds   |     bool     |              false              |
| selectedColor   | Colors.black |              false              |
| unSelectedColor | Colors.grey  |              false              |
| height          |    double    |              100.0              |
| fontSize        |    double    |              16.0               |
| onTimeChange    |   callback   |                                 |

## Usage
```dart

Widget widget() {
  return TimeSpinnerPickerPlus(
    selectedColor: Colors.red,
    unSelectedColor:Colors.green,
    is24h: false,
    isShowSeconds: true,
    onTimeChange: (value) {
      setState(() {
        data = value.toString();
      });
    },
  );
}
```
For more customization options and advanced usage, refer to the [API documentation](#).

## Additional information

A beautiful and animated time picker spinner