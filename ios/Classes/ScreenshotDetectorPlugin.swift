import Flutter
import UIKit

public class ScreenshotDetectorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = ScreenshotDetectorPlugin()
        let eventChannel = FlutterEventChannel(name: "screenshot_detector", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)

        let methodChannel = FlutterMethodChannel(name: "screenshot_detector_method", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "cancelStream" {
            onCancel(withArguments: nil)
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(userDidTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        self.eventSink = nil
        return nil
    }

    @objc private func userDidTakeScreenshot() {
        eventSink?("screenshot_taken")
    }
}
