package com.example.sendbox

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import android.telephony.SmsMessage
import io.flutter.plugin.common.MethodChannel

class SmsReceiver(private val channel: MethodChannel) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            val bundle: Bundle? = intent.extras
            if (bundle != null) {
                val pdus = bundle.get("pdus") as Array<*>?
                if (pdus != null) {
                    val messages = arrayOfNulls<SmsMessage>(pdus.size)
                    for (i in pdus.indices) {
                        val format = bundle.getString("format")
                        messages[i] = SmsMessage.createFromPdu(pdus[i] as ByteArray, format)
                    }
                    
                    for (message in messages) {
                        message?.let {
                            val phoneNumber = it.displayOriginatingAddress
                            val messageBody = it.messageBody
                            val timestamp = it.timestampMillis
                            
                            // Flutter에 SMS 수신 알림
                            channel?.invokeMethod("onSmsReceived", mapOf(
                                "phoneNumber" to phoneNumber,
                                "message" to messageBody,
                                "timestamp" to timestamp
                            ))
                        }
                    }
                }
            }
        }
    }
}

