package id.ssajudn.equran_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import org.json.JSONObject
import java.util.Calendar
import java.util.Locale
import java.text.SimpleDateFormat
import java.util.Date

class ShalatWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"
        private const val DATA_KEY = "shalat_widget_data"
        private val WAKTU_LIST = listOf("subuh", "dzuhur", "ashar", "maghrib", "isya")
    }

    override fun onEnabled(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        if (!prefs.contains(DATA_KEY)) {
            val defaultJson = JSONObject().apply {
                put("totalCount", 0)
                put("totalWaktu", 5)
                val statuses = JSONObject()
                val jadwal = JSONObject()
                for (w in WAKTU_LIST) {
                    statuses.put(w, "belumDicatat")
                    jadwal.put(w, "--:--")
                }
                put("statuses", statuses)
                put("jadwal", jadwal)
                val todayDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
                put("date", todayDate)
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
            val textSecondary = if (isDark) 0xFFA0AAB2.toInt() else 0xFF666666.toInt()
            val dividerColor = if (isDark) 0xFF2A3D2F.toInt() else 0xFFEEF4F0.toInt()

            views.setTextColor(R.id.next_prayer_title, textPrimary)
            views.setTextColor(R.id.progress_text, textSecondary)
            views.setInt(R.id.divider, "setBackgroundColor", dividerColor)

            if (jsonStr != null) {
                try {
                    val json = JSONObject(jsonStr)
                    val todayDate = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
                    val savedDate = json.optString("date", "")
                    val isToday = savedDate == todayDate

                    val totalCount = if (isToday) json.optInt("totalCount", 0) else 0
                    val totalWaktu = json.optInt("totalWaktu", 5)
                    views.setTextViewText(R.id.progress_text, "Progress Hari Ini: $totalCount/$totalWaktu")

                    val statuses = if (isToday) json.optJSONObject("statuses") ?: JSONObject() else JSONObject()
                    val jadwal = if (isToday) json.optJSONObject("jadwal") ?: JSONObject() else JSONObject()

                    val calendar = Calendar.getInstance()
                    val nowMinutes = calendar.get(Calendar.HOUR_OF_DAY) * 60 + calendar.get(Calendar.MINUTE)

                    val timesInMinutes = mutableMapOf<String, Int>()
                    for (w in WAKTU_LIST) {
                        val t = jadwal.optString(w, "")
                        if (t.isNotEmpty() && t.contains(":")) {
                            val parts = t.split(":")
                            if (parts.size >= 2) {
                                val h = parts[0].replace(Regex("[^0-9]"), "").toIntOrNull() ?: 0
                                val m = parts[1].replace(Regex("[^0-9]"), "").toIntOrNull() ?: 0
                                timesInMinutes[w] = h * 60 + m
                            }
                        }
                    }

                    var nextWaktuIdx = -1
                    for (i in 0 until WAKTU_LIST.size) {
                        val w = WAKTU_LIST[i]
                        val t = timesInMinutes[w] ?: 0
                        if (t > nowMinutes) {
                            nextWaktuIdx = i
                            break
                        }
                    }

                    val currentWaktu: String
                    val nextWaktu: String
                    val nextTimeStr: String
                    val nextTitle: String

                    val capitalize = { s: String -> s.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() } }

                    if (nextWaktuIdx == -1) {
                        currentWaktu = "isya"
                        nextWaktu = "subuh"
                        nextTimeStr = jadwal.optString("subuh", "--:--")
                        nextTitle = "Menunggu Subuh (Esok)"
                    } else {
                        nextWaktu = WAKTU_LIST[nextWaktuIdx]
                        nextTimeStr = jadwal.optString(nextWaktu, "--:--")
                        nextTitle = "Menunggu ${capitalize(nextWaktu)}"
                        if (nextWaktuIdx == 0) {
                            currentWaktu = "isya"
                        } else {
                            currentWaktu = WAKTU_LIST[nextWaktuIdx - 1]
                        }
                    }

                    views.setTextViewText(R.id.next_prayer_title, nextTitle)
                    views.setTextViewText(R.id.next_prayer_time, nextTimeStr)

                    val currentStatus = statuses.optString(currentWaktu, "belumDicatat")
                    if (currentStatus == "tepatWaktu" || currentStatus == "qadha") {
                        views.setViewVisibility(R.id.current_prayer_action, android.view.View.GONE)
                        views.setViewVisibility(R.id.current_prayer_done, android.view.View.VISIBLE)
                        views.setTextViewText(R.id.current_prayer_done, "✓ Alhamdulillah, ${capitalize(currentWaktu)} Selesai")
                    } else {
                        views.setViewVisibility(R.id.current_prayer_action, android.view.View.VISIBLE)
                        views.setViewVisibility(R.id.current_prayer_done, android.view.View.GONE)
                        val btnText = if (currentStatus == "tidakShalat") "Tebus Qadha ${capitalize(currentWaktu)}" else "Mulai Sholat ${capitalize(currentWaktu)}"
                        views.setTextViewText(R.id.current_prayer_action, btnText)
                    }

                } catch (e: Exception) {
                    views.setTextViewText(R.id.next_prayer_title, "Menunggu Waktu Sholat")
                    views.setTextViewText(R.id.next_prayer_time, "--:--")
                }
            } else {
                views.setTextViewText(R.id.next_prayer_title, "Menunggu Waktu Sholat")
                views.setTextViewText(R.id.next_prayer_time, "--:--")
            }

            // Open app on tap
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
