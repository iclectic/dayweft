package app.dayweft.dayweft_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.SystemClock
import android.provider.Settings
import java.util.UUID

class MainActivity : FlutterActivity() {
    companion object {
        private val processToken = UUID.randomUUID().toString()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.dayweft/focus_time")
            .setMethodCallHandler { call, result ->
                if (call.method != "read") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val bootCount = try {
                    Settings.Global.getInt(contentResolver, Settings.Global.BOOT_COUNT, -1)
                } catch (_: SecurityException) { -1 }
                result.success(mapOf(
                    "wallMilliseconds" to System.currentTimeMillis(),
                    "elapsedMilliseconds" to SystemClock.elapsedRealtime(),
                    "bootToken" to if (bootCount >= 0) "boot:$bootCount" else "process:$processToken"
                ))
            }
    }
}
