package id.ssajudn.equran_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.Configuration
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import android.widget.Toast
import org.json.JSONObject

class ShalatWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"
        private const val DATA_KEY = "shalat_widget_data"
        private const val ACTION_SET_STATUS = "id.ssajudn.equran_app.SET_SHALAT_STATUS"

        private val WAKTU_LIST = listOf("subuh", "dzuhur", "ashar", "maghrib", "isya")
        private val STATUS_NAMES = listOf("tepat", "qadha", "tidak")
        private val STATUS_MAP = mapOf(
            "tepat" to "tepatWaktu",
            "qadha" to "qadha",
            "tidak" to "tidakShalat",
        )

        private fun statusColor(status: String): Int = when (status) {
            "tepatWaktu" -> 0xFF4CAF50.toInt()
            "qadha" -> 0xFFFF9800.toInt()
            "tidakShalat" -> 0xFFF44336.toInt()
            else -> 0xFF9E9E9E.toInt()
        }

        private fun chipColor(status: String): Int = when (status) {
            "tepat" -> 0xFF4CAF50.toInt()
            "qadha" -> 0xFFFF9800.toInt()
            "tidak" -> 0xFFF44336.toInt()
            else -> 0xFF9E9E9E.toInt()
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d("ShalatWidget", "onReceive action=${intent.action}")
        if (ACTION_SET_STATUS == intent.action) {
            val waktu = intent.getStringExtra("waktu") ?: return
            val targetStatus = intent.getStringExtra("targetStatus") ?: return
            setShalatStatus(context, waktu, targetStatus)
            return
        }
        super.onReceive(context, intent)
    }

    override fun onEnabled(context: Context) {
        Log.d("ShalatWidget", "onEnabled")
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        if (!prefs.contains(DATA_KEY)) {
            val defaultJson = JSONObject().apply {
                put("totalCount", 0)
                put("totalWaktu", 5)
                val statuses = JSONObject()
                for (w in WAKTU_LIST) statuses.put(w, "belumDicatat")
                put("statuses", statuses)
            }
            Log.d("ShalatWidget", "onEnabled writing default: $defaultJson")
            prefs.edit().putString(DATA_KEY, defaultJson.toString()).apply()
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d("ShalatWidget", "onUpdate ids=${appWidgetIds.joinToString()}")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun setShalatStatus(context: Context, waktu: String, targetStatus: String) {
        val fullStatus = STATUS_MAP[targetStatus] ?: return

        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val jsonStr = prefs.getString(DATA_KEY, null) ?: return

        try {
            val json = JSONObject(jsonStr)
            val statuses = json.optJSONObject("statuses") ?: JSONObject()
            val current = statuses.optString(waktu, "belumDicatat")

            // If already set, ignore (matches app behavior)
            if (current != "belumDicatat") return

            statuses.put(waktu, fullStatus)
            json.put("statuses", statuses)

            var count = 0
            for (w in WAKTU_LIST) {
                val s = statuses.optString(w)
                if (s == "tepatWaktu" || s == "qadha") count++
            }
            json.put("totalCount", count)

            prefs.edit().putString(DATA_KEY, json.toString()).apply()

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val ids = appWidgetManager.getAppWidgetIds(
                ComponentName(context, ShalatWidgetProvider::class.java)
            )
            for (id in ids) {
                updateWidget(context, appWidgetManager, id)
            }
        } catch (_: Exception) {
            // ignore
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        try {
            val views = RemoteViews(context.packageName, R.layout.shalat_widget)
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val jsonStr = prefs.getString(DATA_KEY, null)

            val isDark = (context.resources.configuration.uiMode and
                Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES
            val textPrimary = if (isDark) 0xFFE0E0E0.toInt() else 0xFF1A1A1A.toInt()
            val chipBg = if (isDark) 0xFF333333.toInt() else 0xFFE8E8E8.toInt()
            val chipText = if (isDark) 0xFF888888.toInt() else 0xFF999999.toInt()

            if (jsonStr != null) {
                try {
                    val json = JSONObject(jsonStr)
                    val totalCount = json.optInt("totalCount", 0)
                    val totalWaktu = json.optInt("totalWaktu", 5)

                    views.setTextViewText(
                        R.id.widget_title,
                        "Check-in Hari Ini  ·  $totalCount/$totalWaktu"
                    )
                    views.setTextColor(R.id.widget_title, textPrimary)

                    val statuses = json.optJSONObject("statuses")
                    if (statuses != null) {
                        for (waktu in WAKTU_LIST) {
                            val currentStatus = statuses.optString(waktu, "belumDicatat")

                            val labelId = context.resources.getIdentifier(
                                "label_$waktu", "id", context.packageName
                            )
                            if (labelId != 0) {
                                views.setTextColor(labelId, textPrimary)
                            }

                            // Render each of the 3 status chips
                            for (chipName in STATUS_NAMES) {
                                val chipFullStatus = STATUS_MAP[chipName]!!
                                val isSelected = currentStatus == chipFullStatus
                                val chipId = context.resources.getIdentifier(
                                    "${chipName}_$waktu", "id", context.packageName
                                )
                                if (chipId != 0) {
                                    if (isSelected) {
                                        val color = chipColor(chipName)
                                        views.setInt(chipId, "setBackgroundColor", color)
                                        views.setTextColor(chipId, 0xFFFFFFFF.toInt())
                                    } else {
                                        views.setInt(chipId, "setBackgroundColor", chipBg)
                                        views.setTextColor(chipId, chipText)
                                    }

                                    // Set PendingIntent — only fire if belumDicatat
                                    val intent = Intent(
                                        context, ShalatWidgetProvider::class.java
                                    ).apply {
                                        action = ACTION_SET_STATUS
                                        putExtra("waktu", waktu)
                                        putExtra("targetStatus", chipName)
                                    }
                                    val pi = PendingIntent.getBroadcast(
                                        context,
                                        "${waktu}_$chipName".hashCode(),
                                        intent,
                                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                                    )
                                    views.setOnClickPendingIntent(chipId, pi)
                                }
                            }
                        }
                    }
                } catch (_: Exception) {
                    views.setTextViewText(R.id.widget_title, "Check-in Hari Ini")
                }
            } else {
                views.setTextViewText(R.id.widget_title, "Check-in Hari Ini")
            }

            views.setTextColor(R.id.widget_title, textPrimary)

            // Open app on card tap
            val intent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("qurva:///statistik-shalat")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        } catch (e: Exception) {
            Log.e("ShalatWidget", "updateWidget error", e)
        }
    }
}
