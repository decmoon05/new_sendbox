package com.example.sendbox

import android.content.IntentFilter
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.sendbox.app/sms"
    private lateinit var smsReceiver: SmsReceiver
    private lateinit var smsChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        smsChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        smsReceiver = SmsReceiver(smsChannel)
        
        // SMS 수신 대기 시작
        val filter = IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION)
        registerReceiver(smsReceiver, filter)
        
        // MethodChannel 핸들러 설정
        smsChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSms" -> {
                    // TODO: SMS 전송 구현
                    result.success(false)
                }
                "startListening" -> {
                    // 이미 리시버가 등록되어 있음
                    result.success(null)
                }
                "stopListening" -> {
                    try {
                        unregisterReceiver(smsReceiver)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to stop listening", null)
                    }
                }
                "getSmsMessages" -> {
                    // TODO: SMS 메시지 가져오기 구현
                    result.success(emptyList<Map<String, Any>>())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(smsReceiver)
        } catch (e: Exception) {
            // 리시버가 등록되지 않았을 수 있음
        }
    }
}
