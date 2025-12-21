package com.sendbox.app

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

/**
 * Notification Listener Service
 * 모든 앱의 알림을 감지하고 카카오톡 알림을 필터링하여 Broadcast로 전달
 */
class SendBoxNotificationListenerService : NotificationListenerService() {
    
    companion object {
        private const val TAG = "NotificationListener"
        const val ACTION_NOTIFICATION_RECEIVED = "com.sendbox.app.NOTIFICATION_RECEIVED"
        const val EXTRA_PACKAGE_NAME = "packageName"
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"
        const val EXTRA_TIMESTAMP = "timestamp"
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Notification Listener Service 생성")
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Notification Listener Service 종료")
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

            // Broadcast로 데이터 전송 (MainActivity에서 수신)
            val intent = Intent(ACTION_NOTIFICATION_RECEIVED).apply {
                putExtra(EXTRA_PACKAGE_NAME, packageName)
                putExtra(EXTRA_TITLE, title)
                putExtra(EXTRA_BODY, messageBody)
                putExtra(EXTRA_TIMESTAMP, System.currentTimeMillis())
            }
            sendBroadcast(intent)
            
            Log.d(TAG, "카카오톡 알림 Broadcast 전송 완료")
            
        } catch (e: Exception) {
            Log.e(TAG, "알림 처리 중 오류 발생", e)
        }
    }

    override fun onNotificationRemoved(notification: StatusBarNotification?) {
        super.onNotificationRemoved(notification)
        // 알림 제거 시 처리 (필요시 구현)
    }
}
