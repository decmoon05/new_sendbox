package com.sendbox.app

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel

/**
 * Notification Listener Service
 * 모든 앱의 알림을 감지하고 카카오톡 알림을 필터링하여 Flutter로 전달
 */
class SendBoxNotificationListenerService : NotificationListenerService() {
    private var eventChannel: EventChannel? = null
    private var flutterEngine: FlutterEngine? = null
    
    companion object {
        private const val TAG = "NotificationListener"
        private const val EVENT_CHANNEL_NAME = "com.sendbox.app/kakao_notifications"
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Notification Listener Service 생성")
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Notification Listener Service 종료")
    }

    /**
     * Flutter Engine 연결
     */
    fun setFlutterEngine(engine: FlutterEngine) {
        flutterEngine = engine
        eventChannel = EventChannel(
            engine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL_NAME
        )
        Log.d(TAG, "Flutter Engine 연결됨")
    }

    override fun onNotificationPosted(notification: StatusBarNotification?) {
        super.onNotificationPosted(notification)
        
        if (notification == null) return

        val packageName = notification.packageName ?: return
        
        // 카카오톡 알림만 필터링
        if (packageName != "com.kakao.talk" && packageName != "com.kakao.talk.plus") {
            return
        }

        Log.d(TAG, "카카오톡 알림 감지: $packageName")

        try {
            // 알림에서 정보 추출
            val notificationData = notification.notification
            val extras = notificationData?.extras
            
            val title = extras?.getCharSequence(android.app.Notification.EXTRA_TITLE)?.toString() ?: ""
            val text = extras?.getCharSequence(android.app.Notification.EXTRA_TEXT)?.toString() ?: ""
            val bigText = extras?.getCharSequence(android.app.Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
            
            // 메시지 내용 결정 (bigText가 있으면 사용, 없으면 text 사용)
            val messageBody = if (bigText.isNotEmpty()) bigText else text

            if (messageBody.isEmpty() && title.isEmpty()) {
                Log.d(TAG, "알림 내용이 비어있어 무시됨")
                return
            }

            // Flutter로 전달할 데이터 생성
            val data = mapOf(
                "packageName" to packageName,
                "title" to title,
                "body" to messageBody,
                "timestamp" to System.currentTimeMillis()
            )

            // EventChannel로 데이터 전송 (비동기)
            flutterEngine?.dartExecutor?.executeDartCallback {
                eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        // 스트림 핸들러는 이미 설정되어 있을 것이므로, 직접 데이터를 보낼 수 없음
                        // 대신 EventSink를 저장하고 여기서 사용해야 하지만,
                        // 현재 구조에서는 각 알림마다 새로운 데이터를 보낼 방법이 필요함
                        // 이 부분은 MainActivity에서 EventChannel을 관리하는 방식으로 변경 필요
                    }

                    override fun onCancel(arguments: Any?) {
                        // 취소 처리
                    }
                })
            }

            Log.d(TAG, "카카오톡 알림 데이터 준비 완료: $data")
            
            // 실제로는 MainActivity를 통해 데이터를 전송해야 함
            // 이 구조는 리팩토링이 필요함
            
        } catch (e: Exception) {
            Log.e(TAG, "알림 처리 중 오류 발생", e)
        }
    }

    override fun onNotificationRemoved(notification: StatusBarNotification?) {
        super.onNotificationRemoved(notification)
        // 알림 제거 시 처리 (필요시 구현)
    }
}

