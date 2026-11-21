package com.example.kelompok_strava_uas_moprog

import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File

class MainActivity : FlutterActivity() {
    private val shareChannel = "kelompok_strava_uas_moprog/club_share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shareChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getShareTargets" -> result.success(getInstalledShareTargets())
                    "shareToApp" -> {
                        val text = call.argument<String>("text") ?: ""
                        val imagePath = call.argument<String>("imagePath")
                        val packageName = call.argument<String>("packageName")
                        val activityName = call.argument<String>("activityName")
                        val ok = if (packageName.isNullOrEmpty()) {
                            false
                        } else {
                            launchDirectShare(text, imagePath, packageName, activityName)
                        }
                        result.success(ok)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun queryHandlers(mimeType: String): List<ResolveInfo> {
        val intent = Intent(Intent.ACTION_SEND).apply { type = mimeType }
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.queryIntentActivities(
                intent,
                PackageManager.ResolveInfoFlags.of(0)
            )
        } else {
            @Suppress("DEPRECATION")
            packageManager.queryIntentActivities(intent, 0)
        }
    }

    private fun getInstalledShareTargets(): List<Any> {
        val imagePackages = queryHandlers("image/*")
            .mapNotNull { it.activityInfo?.packageName }
            .toSet()

        val combined = LinkedHashMap<String, ResolveInfo>()
        for (info in queryHandlers("image/*") + queryHandlers("text/plain")) {
            val pkg = info.activityInfo?.packageName ?: continue
            if (pkg == applicationContext.packageName) continue
            combined.putIfAbsent(pkg, info)
        }

        return combined.values.map { info ->
            val pkg = info.activityInfo?.packageName ?: ""
            val activity = info.activityInfo?.name ?: ""
            mapOf<String, Any>(
                "label" to info.loadLabel(packageManager).toString(),
                "packageName" to pkg,
                "activityName" to activity,
                "supportsImage" to imagePackages.contains(pkg),
                "icon" to drawableToPngBytes(info.loadIcon(packageManager))
            )
        }
    }

    private fun drawableToPngBytes(drawable: Drawable): ByteArray {
        val size = 96
        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        bitmap.recycle()
        return stream.toByteArray()
    }

    private fun launchDirectShare(
        text: String,
        imagePath: String?,
        packageName: String,
        activityName: String?
    ): Boolean {
        return try {
            val file = imagePath?.let { File(it) }?.takeIf { it.exists() }
            val intent = Intent(Intent.ACTION_SEND).apply {
                if (file != null) {
                    val uri = FileProvider.getUriForFile(
                        this@MainActivity,
                        "${applicationContext.packageName}.club_share_provider",
                        file
                    )
                    type = "image/png"
                    putExtra(Intent.EXTRA_STREAM, uri)
                    if (text.isNotEmpty()) putExtra(Intent.EXTRA_TEXT, text)
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                } else {
                    type = "text/plain"
                    putExtra(Intent.EXTRA_TEXT, text)
                }

                if (!activityName.isNullOrEmpty()) {
                    setClassName(packageName, activityName)
                } else {
                    setPackage(packageName)
                }
            }
            startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }
}