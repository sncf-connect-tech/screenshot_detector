// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_detector/screenshot_detector_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelScreenshotDetector', () {
    const EventChannel eventChannel = MethodChannelScreenshotDetector.eventChannel;
    late MethodChannelScreenshotDetector detector;

    setUp(() {
      detector = MethodChannelScreenshotDetector();
    });

    void simulateEvent(dynamic event) {
      ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
        eventChannel.name,
        eventChannel.codec.encodeSuccessEnvelope(event),
        (_) {},
      );
    }

    test('startListening calls onScreenshot when screenshot_taken event is received', () async {
      bool callbackCalled = false;

      // Configurer le mock du `EventChannel`
      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        eventChannel.name,
        (ByteData? message) async {
          // Simuler l'abonnement
          final MethodCall methodCall = const StandardMethodCodec().decodeMethodCall(message!);
          if (methodCall.method == 'listen') {
            // Simuler l'envoi de l'événement 'screenshot_taken'
            simulateEvent('screenshot_taken');
          }
          return null;
        },
      );

      detector.startListening(() {
        callbackCalled = true;
      });

      // Attendre que les messages asynchrones soient traités
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, isTrue);
    });

    test('startListening does not call onScreenshot for other events', () async {
      bool callbackCalled = false;

      ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        eventChannel.name,
        (ByteData? message) async {
          final MethodCall methodCall = const StandardMethodCodec().decodeMethodCall(message!);
          if (methodCall.method == 'listen') {
            // Simuler l'envoi d'un autre événement
            simulateEvent('other_event');
          }
          return null;
        },
      );

      detector.startListening(() {
        callbackCalled = true;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, isFalse);
    });
  });
}
