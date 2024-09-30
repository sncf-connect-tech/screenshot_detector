import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screenshot_detector_platform_interface.dart';

/// An implementation of [ScreenshotDetectorPlatform] that uses method channels.
class MethodChannelScreenshotDetector extends ScreenshotDetectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const EventChannel eventChannel = EventChannel('screenshot_detector');
  StreamSubscription<dynamic>? _eventSubscription;

  @override
  void startListening(void Function() onScreenshot) {
    _eventSubscription = eventChannel.receiveBroadcastStream().listen((event) {
      if (event == 'screenshot_taken') {
        onScreenshot();
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}
