package sncf_connect.screenshot_detector

import ScreenshotObserver

import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel

class ScreenshotDetectorPlugin : FlutterPlugin, EventChannel.StreamHandler {

    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var screenshotObserver: ScreenshotObserver? = null
    private var context: Context? = null

    companion object {
        private const val EVENT_CHANNEL_NAME = "screenshot_detector"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel?.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel?.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        startListening()
    }

    override fun onCancel(arguments: Any?) {
        stopListening()
    }

    private fun startListening() {
        val handler = Handler(Looper.getMainLooper())
        screenshotObserver = ScreenshotObserver(handler, context!!.contentResolver, eventSink)
        context!!.contentResolver.registerContentObserver(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            true,
            screenshotObserver!!
        )
    }

    private fun stopListening() {
        if (screenshotObserver != null) {
            context!!.contentResolver.unregisterContentObserver(screenshotObserver!!)
            screenshotObserver = null
        }
    }
}
