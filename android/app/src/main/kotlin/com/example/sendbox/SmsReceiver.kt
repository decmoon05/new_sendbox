package com.example.sendbox

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import android.telephony.SmsMessage

typealias SmsReceivedCallback = (String, String, Long) -> Unit

class SmsReceiver(private val onSmsReceived: SmsReceivedCallback) : BroadcastReceiver() {
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
                            
                            // 콜백을 통해 MainActivity로 SMS 수신 알림
                            onSmsReceived(phoneNumber, messageBody, timestamp)
                        }
                    }
                }
            }
        }
    }
}
