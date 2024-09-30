import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_detector/screenshot_detector_platform_interface.dart';
import 'package:screenshot_detector_example/main.dart';

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
  testWidgets('Displays correct widget before and after screenshot', (WidgetTester tester) async {
    // Créer une instance de la fake plateforme
    final fakePlatform = FakeScreenshotDetectorPlatform();
    ScreenshotDetectorPlatform.instance = fakePlatform;

    // Construire l'application
    await tester.pumpWidget(const MyApp());

    // Vérifier que le bouton 'Share' est affiché
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Screenshot Detected'), findsNothing);

    // Simuler la capture d'écran
    fakePlatform.simulateScreenshot();

    // Attendre que le widget réagisse au changement
    await tester.pumpAndSettle();

    // Vérifier que le texte 'Screenshot Detected' est affiché
    expect(find.text('Share'), findsNothing);
    expect(find.text('Screenshot Detected'), findsOneWidget);
  });
}
