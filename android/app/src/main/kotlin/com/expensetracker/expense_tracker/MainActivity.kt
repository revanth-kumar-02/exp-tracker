package com.expensetracker.expense_tracker

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

object NotificationStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private val pendingEvents = mutableListOf<Map<String, Any?>>()

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        synchronized(pendingEvents) {
            for (event in pendingEvents) {
                eventSink?.success(event)
            }
            pendingEvents.clear()
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun dispatch(event: Map<String, Any?>) {
        val sink = eventSink
        if (sink != null) {
            sink.success(event)
        } else {
            synchronized(pendingEvents) {
                if (pendingEvents.size > 50) pendingEvents.removeAt(0)
                pendingEvents.add(event)
            }
        }
    }
}

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "com.expensetracker/bridge"
    private val EVENT_CHANNEL = "com.expensetracker/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setup EventChannel for streaming notification events
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(NotificationStreamHandler)

        // Setup MethodChannel for permissions and system actions
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isNotificationPermissionGranted" -> {
                        val packageName = applicationContext.packageName
                        val enabledPackages = NotificationManagerCompat.getEnabledListenerPackages(applicationContext)
                        val isGranted = enabledPackages.contains(packageName)
                        result.success(isGranted)
                    }
                    "openNotificationSettings" -> {
                        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
