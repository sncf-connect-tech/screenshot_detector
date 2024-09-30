import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:screenshot_detector/screenshot_detector.dart';
import 'package:screenshot_detector/screenshot_detector_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenshotDetectorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ScreenshotDetectorPlatform {}

class FakeScreenshotDetectorPlatform extends ScreenshotDetectorPlatform {
  VoidCallback? _onScreenshot;

  @override
  void startListening(VoidCallback onScreenshot) {
    _onScreenshot = onScreenshot;
  }

  void simulateScreenshot() {
    _onScreenshot?.call();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

void main() {
  group('ScreenshotDetector', () {
    late ScreenshotDetector screenshotDetector;
    late MockScreenshotDetectorPlatform mockPlatform;

    setUp(() {
      mockPlatform = MockScreenshotDetectorPlatform();
      ScreenshotDetectorPlatform.instance = mockPlatform;
      screenshotDetector = ScreenshotDetector.instance;
    });

    test('startListening calls platform interface method', () {
      callback() {}
      screenshotDetector.startListening(callback);

      verify(mockPlatform.startListening(callback)).called(1);
    });
  });

  group('ScreenShotDetectorWrapper', () {
    testWidgets('Displays replaceChild when screenshot is detected', (WidgetTester tester) async {
      final fakePlatform = FakeScreenshotDetectorPlatform();
      ScreenshotDetectorPlatform.instance = fakePlatform;

      // Create widgets for the test
      const testKey = Key('test_child');
      const replaceKey = Key('replace_child');

      await tester.pumpWidget(
        MaterialApp(
          home: ScreenShotDetectorWrapper(
            onScreenshot: Container(key: replaceKey),
            child: Container(key: testKey),
          ),
        ),
      );

      // Verify that the initial child is displayed
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.byKey(replaceKey), findsNothing);

      // Simulate the screenshot detection
      fakePlatform.simulateScreenshot();

      // Wait for the widget to respond to the stream change
      await tester.pumpAndSettle();

      // Verify that the replaceChild is displayed
      expect(find.byKey(testKey), findsNothing);
      expect(find.byKey(replaceKey), findsOneWidget);
    });
  });
}
