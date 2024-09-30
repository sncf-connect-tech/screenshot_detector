import 'dart:async';
import 'package:flutter/widgets.dart';
import 'screenshot_detector_platform_interface.dart';

class ScreenshotDetector {
  ScreenshotDetector._();
  static final ScreenshotDetector instance = ScreenshotDetector._();

  final StreamController<bool> onScreenshotController = StreamController<bool>.broadcast();

  void startListening(void Function() onScreenshot) {
    return ScreenshotDetectorPlatform.instance.startListening(onScreenshot);
  }

  void _startListeningStream() => startListening(() {
        onScreenshotController.add(true);
      });

  void disposeStream() {
    onScreenshotController.close();
    ScreenshotDetectorPlatform.instance.dispose();
  }
}

class ScreenShotDetectorWrapper extends StatefulWidget {
  final Widget child;
  final Widget onScreenshot;

  const ScreenShotDetectorWrapper({super.key, required this.onScreenshot, required this.child});

  @override
  State<ScreenShotDetectorWrapper> createState() => _ScreenShotDetectorWrapperState();
}

class _ScreenShotDetectorWrapperState extends State<ScreenShotDetectorWrapper> {
  final screenshotDetector = ScreenshotDetector.instance;

  @override
  void initState() {
    super.initState();
    screenshotDetector._startListeningStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: screenshotDetector.onScreenshotController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return widget.onScreenshot;
        } else {
          return widget.child;
        }
      },
    );
  }
}
