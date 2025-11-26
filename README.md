# Animated Unique ListTile Package

This package provides a customizable animated ListTile widget (`AnimatedUniqueListTile`) that includes:

* Entrance animation (fade + slide)
* Expand/Collapse interaction
* Animated trailing icon rotation
* Optional subtitle with animated size
* Optional badge widget
* Customizable leading widget with Hero animation
* Clean, modern UI design

An example demo is included showing how to use the widget inside a simple list.

## Features

* ⚡ Smooth entrance animation
* 📌 Expand/collapse extra content
* 🔄 Animated trailing icon
* 🎖 Optional badge support
* 🎨 Works with light/dark themes

## Usage

### Import

```dart
import 'package:your_package_name/animated_list_tile.dart';
```

### Example

```dart
AnimatedUniqueListTile(
  title: Text('Example Item'),
  subtitle: Text('Subtitle here'),
  leading: Icon(Icons.star),
  badge: Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text('NEW', style: TextStyle(color: Colors.white)),
  ),
  onTap: () {
    print('Tapped!');
  },
)
```

## Running the Demo

The file contains a minimal `main()` showcasing the animated tiles:

```dart
void main() => runApp(const DemoApp());
```

## Requirements

* Flutter 3.0+
* Dart 2.17+

## Contributing

Pull requests and improvements are welcome!

## License

This package is distributed under the MIT License. See the `LICENSE` file for details.
