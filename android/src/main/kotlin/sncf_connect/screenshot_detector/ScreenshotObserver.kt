import android.content.ContentResolver
import android.database.ContentObserver
import android.database.Cursor
import android.net.Uri
import android.os.Handler
import android.provider.MediaStore
import android.util.Log
import io.flutter.plugin.common.EventChannel

class ScreenshotObserver(
    handler: Handler,
    private val contentResolver: ContentResolver,
    private val eventSink: EventChannel.EventSink?
) : ContentObserver(handler) {

    companion object {
        private const val TAG = "ScreenshotObserver"
    }

    override fun onChange(selfChange: Boolean, uri: Uri?) {
        super.onChange(selfChange, uri)

        var cursor: Cursor? = null
        try {
            cursor = contentResolver.query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                null,
                null,
                null,
                "${MediaStore.Images.Media.DATE_ADDED} DESC"
            )

            if (cursor != null && cursor.moveToFirst()) {
                val path = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA))
                val dateAdded = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_ADDED))

                if (isScreenshot(path)) {
                    Log.d(TAG, "Capture d'écran détectée : $path")

                    // Envoyer un événement à Flutter
                    eventSink?.success("screenshot_taken")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Erreur lors de la lecture du MediaStore", e)
        } finally {
            cursor?.close()
        }
    }

    private fun isScreenshot(path: String?): Boolean {
        return path?.lowercase()?.contains("screenshot") == true
    }
}
