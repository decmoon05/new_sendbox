package com.sendbox.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.sendbox.app/kakao_listener"
    private val EVENT_CHANNEL_NAME = "com.sendbox.app/kakao_notifications"
    
    private var eventSink: EventChannel.EventSink? = null
    private var notificationReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel 설정 (권한 확인 등)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasNotificationListenerPermission" -> {
                    val hasPermission = isNotificationListenerEnabled()
                    result.success(hasPermission)
                }
                "requestNotificationListenerPermission" -> {
                    requestNotificationListenerPermission()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // EventChannel 설정 (알림 데이터 전송)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_NAME).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d("MainActivity", "EventChannel 리스너 설정됨")
                    
                    // BroadcastReceiver 등록
                    registerNotificationReceiver()
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.d("MainActivity", "EventChannel 리스너 취소됨")
                    
                    // BroadcastReceiver 해제
                    unregisterNotificationReceiver()
                }
            }
        )
    }

    /**
     * Notification Listener 권한 확인
     */
    private fun isNotificationListenerEnabled(): Boolean {
        val enabledListeners = Settings.Secure.getString(
            contentResolver,
            "enabled_notification_listeners"
        )
        
        return enabledListeners?.contains(packageName) == true
    }

    /**
     * Notification Listener 권한 요청
     */
    private fun requestNotificationListenerPermission() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        startActivity(intent)
    }

    /**
     * 알림 BroadcastReceiver 등록
     */
    private fun registerNotificationReceiver() {
        if (notificationReceiver != null) return
        
        notificationReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == SendBoxNotificationListenerService.ACTION_NOTIFICATION_RECEIVED) {
                    val data = mapOf(
                        "packageName" to (intent.getStringExtra(SendBoxNotificationListenerService.EXTRA_PACKAGE_NAME) ?: ""),
                        "title" to (intent.getStringExtra(SendBoxNotificationListenerService.EXTRA_TITLE) ?: ""),
                        "body" to (intent.getStringExtra(SendBoxNotificationListenerService.EXTRA_BODY) ?: ""),
                        "timestamp" to (intent.getLongExtra(SendBoxNotificationListenerService.EXTRA_TIMESTAMP, 0L))
                    )
                    
                    Log.d("MainActivity", "알림 데이터 수신: $data")
                    eventSink?.success(data)
                }
            }
        }
        
        val filter = IntentFilter(SendBoxNotificationListenerService.ACTION_NOTIFICATION_RECEIVED)
        registerReceiver(notificationReceiver, filter)
        Log.d("MainActivity", "Notification BroadcastReceiver 등록됨")
    }

    /**
     * 알림 BroadcastReceiver 해제
     */
    private fun unregisterNotificationReceiver() {
        notificationReceiver?.let {
            try {
                unregisterReceiver(it)
                notificationReceiver = null
                Log.d("MainActivity", "Notification BroadcastReceiver 해제됨")
            } catch (e: Exception) {
                Log.e("MainActivity", "BroadcastReceiver 해제 중 오류", e)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterNotificationReceiver()
    }
}

