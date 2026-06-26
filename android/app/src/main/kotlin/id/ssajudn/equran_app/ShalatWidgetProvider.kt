package id.ssajudn.equran_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
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

        private fun drawableFor(chipName: String, isSelected: Boolean): Int = when {
            chipName == "tepat" && isSelected -> R.drawable.chip_tepat_selected
            chipName == "tepat" && !isSelected -> R.drawable.chip_tepat_unselected
            chipName == "qadha" && isSelected -> R.drawable.chip_qadha_selected
            chipName == "qadha" && !isSelected -> R.drawable.chip_qadha_unselected
            chipName == "tidak" && isSelected -> R.drawable.chip_tidak_selected
            else -> R.drawable.chip_tidak_unselected
        }

        private fun textColorFor(chipName: String, isSelected: Boolean): Int = when {
            isSelected -> 0xFFFFFFFF.toInt()
            chipName == "tepat" -> 0xFF1A5C38.toInt()
            chipName == "qadha" -> 0xFFF57F17.toInt()
            else -> 0xFFB00020.toInt()
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (ACTION_SET_STATUS == intent.action) {
            val waktu = intent.getStringExtra("waktu") ?: return
            val targetStatus = intent.getStringExtra("targetStatus") ?: return
            setShalatStatus(context, waktu, targetStatus)
            return
        }
        super.onReceive(context, intent)
    }

    override fun onEnabled(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        if (!prefs.contains(DATA_KEY)) {
            val defaultJson = JSONObject().apply {
                put("totalCount", 0)
                put("totalWaktu", 5)
                val statuses = JSONObject()
                for (w in WAKTU_LIST) statuses.put(w, "belumDicatat")
                put("statuses", statuses)
            }
            prefs.edit().putString(DATA_KEY, defaultJson.toString()).apply()
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
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
        } catch (e: Exception) {
            Log.e("ShalatWidget", "setShalatStatus error", e)
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

            val textPrimary = if (isDark) 0xFFE2EDE6.toInt() else 0xFF0D1F16.toInt()
            val dividerColor = if (isDark) 0xFF2A3D2F.toInt() else 0xFFEEF4F0.toInt()

            // Header text
            views.setTextColor(R.id.widget_title, textPrimary)

            // Label colors
            for (waktu in WAKTU_LIST) {
                val labelId = context.resources.getIdentifier(
                    "label_$waktu", "id", context.packageName
                )
                if (labelId != 0) {
                    views.setTextColor(labelId, textPrimary)
                }
            }

            // Divider
            views.setInt(R.id.divider, "setBackgroundColor", dividerColor)

            if (jsonStr != null) {
                try {
                    val json = JSONObject(jsonStr)
                    val totalCount = json.optInt("totalCount", 0)
                    val totalWaktu = json.optInt("totalWaktu", 5)

                    views.setTextViewText(
                        R.id.widget_title,
                        "Check-in Hari Ini  ·  $totalCount/$totalWaktu"
                    )

                    val statuses = json.optJSONObject("statuses")
                    if (statuses != null) {
                        for (waktu in WAKTU_LIST) {
                            val currentStatus = statuses.optString(waktu, "belumDicatat")

                            for (chipName in STATUS_NAMES) {
                                val chipFullStatus = STATUS_MAP[chipName]!!
                                val isSelected = currentStatus == chipFullStatus
                                val chipId = context.resources.getIdentifier(
                                    "${chipName}_$waktu", "id", context.packageName
                                )
                                if (chipId != 0) {
                                    views.setInt(
                                        chipId,
                                        "setBackgroundResource",
                                        drawableFor(chipName, isSelected)
                                    )
                                    views.setTextColor(
                                        chipId,
                                        textColorFor(chipName, isSelected)
                                    )

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
