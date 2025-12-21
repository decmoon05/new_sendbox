package com.example.sendbox

import android.content.IntentFilter
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.sendbox.app/sms"
    private val EVENT_CHANNEL = "com.sendbox.app/sms/events"
    private lateinit var smsReceiver: SmsReceiver
    private lateinit var smsChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        smsChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        
        // EventChannel 스트림 핸들러 설정
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
        
        smsReceiver = SmsReceiver { phoneNumber, message, timestamp ->
            // SMS 수신 시 EventChannel을 통해 Flutter로 전달
            val data = mapOf(
                "phoneNumber" to phoneNumber,
                "message" to message,
                "timestamp" to timestamp
            )
            eventSink?.success(data)
        }
        
        // SMS 수신 대기 시작
        val filter = IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION)
        registerReceiver(smsReceiver, filter)
        
        // MethodChannel 핸들러 설정
        smsChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSms" -> {
                    try {
                        val phoneNumber = call.argument<String>("phoneNumber") ?: ""
                        val message = call.argument<String>("message") ?: ""
                        
                        if (phoneNumber.isEmpty() || message.isEmpty()) {
                            result.error("INVALID_ARGUMENT", "Phone number and message cannot be empty", null)
                            return@setMethodCallHandler
                        }
                        
                        val smsManager = android.telephony.SmsManager.getDefault()
                        val parts = smsManager.divideMessage(message)
                        
                        if (parts.size == 1) {
                            // 단일 메시지
                            smsManager.sendTextMessage(
                                phoneNumber,
                                null,
                                message,
                                null,
                                null
                            )
                            result.success(true)
                        } else {
                            // 긴 메시지 (여러 부분으로 나뉨)
                            val sentIntents = ArrayList<android.app.PendingIntent>()
                            val deliveryIntents = ArrayList<android.app.PendingIntent>()
                            
                            for (i in parts.indices) {
                                sentIntents.add(
                                    android.app.PendingIntent.getBroadcast(
                                        this,
                                        0,
                                        android.content.Intent("SMS_SENT"),
                                        android.app.PendingIntent.FLAG_IMMUTABLE
                                    )
                                )
                                deliveryIntents.add(
                                    android.app.PendingIntent.getBroadcast(
                                        this,
                                        0,
                                        android.content.Intent("SMS_DELIVERED"),
                                        android.app.PendingIntent.FLAG_IMMUTABLE
                                    )
                                )
                            }
                            
                            smsManager.sendMultipartTextMessage(
                                phoneNumber,
                                null,
                                parts,
                                sentIntents,
                                deliveryIntents
                            )
                            result.success(true)
                        }
                    } catch (e: Exception) {
                        result.error("SEND_FAILED", "Failed to send SMS: ${e.message}", null)
                    }
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
                    try {
                        val phoneNumber = call.argument<String>("phoneNumber")
                        val limit = call.argument<Int>("limit") ?: 100
                        
                        val messages = getSmsMessages(phoneNumber, limit)
                        result.success(messages)
                    } catch (e: Exception) {
                        result.error("READ_FAILED", "Failed to read SMS: ${e.message}", null)
                    }
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
    
    /// SMS 메시지 가져오기
    private fun getSmsMessages(phoneNumber: String?, limit: Int): List<Map<String, Any>> {
        val messages = mutableListOf<Map<String, Any>>()
        
        try {
            val uri = android.provider.Telephony.Sms.CONTENT_URI
            val cursor = contentResolver.query(
                uri,
                arrayOf(
                    android.provider.Telephony.Sms._ID,
                    android.provider.Telephony.Sms.ADDRESS,
                    android.provider.Telephony.Sms.BODY,
                    android.provider.Telephony.Sms.DATE,
                    android.provider.Telephony.Sms.TYPE,
                    android.provider.Telephony.Sms.READ
                ),
                if (phoneNumber != null) "${android.provider.Telephony.Sms.ADDRESS} = ?" else                 if (phoneNumber != null) "${android.provider.Telephony.Sms.ADDRESS} = ?" else null,
                if (phoneNumber != null) arrayOf(phoneNumber) else null,
                "${android.provider.Telephony.Sms.DATE} DESC"
            )
            
            cursor?.use {
                val idIndex = it.getColumnIndex(android.provider.Telephony.Sms._ID)
                val addressIndex = it.getColumnIndex(android.provider.Telephony.Sms.ADDRESS)
                val bodyIndex = it.getColumnIndex(android.provider.Telephony.Sms.BODY)
                val dateIndex = it.getColumnIndex(android.provider.Telephony.Sms.DATE)
                val typeIndex = it.getColumnIndex(android.provider.Telephony.Sms.TYPE)
                val readIndex = it.getColumnIndex(android.provider.Telephony.Sms.READ)
                
                while (it.moveToNext() && messages.size < limit) {
                    val message = mapOf(
                        "id" to it.getString(idIndex),
                        "phoneNumber" to it.getString(addressIndex),
                        "message" to it.getString(bodyIndex),
                        "timestamp" to it.getLong(dateIndex),
                        "type" to if (it.getInt(typeIndex) == android.provider.Telephony.Sms.MESSAGE_TYPE_SENT) "sent" else "received",
                        "isRead" to (it.getInt(readIndex) == 1)
                    )
                    messages.add(message)
                }
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error reading SMS: ${e.message}")
        }
        
        return messages
    }
}
