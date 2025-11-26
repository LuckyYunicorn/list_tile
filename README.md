# README

## Animated Unique ListTile

A customizable and beautifully animated ListTile widget for Flutter.
This widget adds:

* Slide & fade-in initial animation
* Expand/collapse behavior
* Animated subtitle & details
* Optional badge
* Leading widget with Hero animation
* Smooth rotation trailing chevron
* Fully customizable appearance

### Features

* 🚀 Smooth entrance animations
* 📦 Drop-in replacement for ListTile
* 🎨 Works with Material You themes
* 🔧 Supports badges, subtitles, hero leading icons, expanded section

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  list_tile_package:
    path: ./list_tile_package
```

### Usage

```dart
AnimatedUniqueListTile(
  leading: CircleAvatar(child: Text('1')),
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  badge: Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text('NEW', style: TextStyle(color: Colors.white)),
  ),
  onTap: () {
    print('Tapped');
  },
)
```

### Example Project

The included `main()` demonstrates how to display a list of animated tiles.

### License

See the LICENSE file below.

---
