# Screenshot Detection Package

This is a private Flutter package designed to detect screenshots taken on native Swift (iOS) and Android platforms and notify the Flutter layer.

## Features

- Detects screenshots on iOS (using Swift) and Android (using native code).
- Provides screenshot detection information to Flutter for further handling.

## Installation

Add the package to your `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  screenshot_detection:
    git:
      url: git@your_private_repository_url.git
      ref: main # Replace with the correct branch or tag
```

Run flutter pub get to install the package.

# Usage

## Listen for Screenshot Events
The package provides a stream that allows you to listen for screenshot events.

```dart
ScreenshotDetector.instance.startListening.listen(() {
    // Handle screenshot event
    print("Screenshot detected!");
});

```
## Listen for Screenshot Events
The package provides a stream that allows you to listen for screenshot events.

```dart
 ScreenShotDetectorWrapper(
              replaceChild: const Text('Screenshot Detected'),
              child: TextButton(
                onPressed: () => {},
                child: const Text(
                  'Share',
            ),
        ),
    )
```
# Contributions
This is a private package. Contributions are welcome only from authorized members.

# License
This package is under a private license. Distribution or usage outside authorized channels is prohibited.