package com.expensetracker.expense_tracker

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class ExpenseNotificationListenerService : NotificationListenerService() {

    companion object {
        private const val TAG = "ExpenseNotificationSvc"

        // Whitelist of supported Indian financial and banking applications
        val SUPPORTED_PACKAGES = setOf(
            "com.snapwork.hdfc",                      // HDFC Bank
            "com.sbi.lotusintouch",                   // Yono SBI
            "com.sbi.upi",                            // BHIM SBI Pay
            "com.csam.icici.bank.imobile",            // ICICI iMobile / Amazon Pay ICICI
            "com.axis.mobile",                        // Axis Mobile
            "com.rblbank.mobank",                     // RBL Bank (MoBank)
            "com.canarabank.ai1",                     // Canara Bank (ai1)
            "indwin.c3.shareSpend",                   // Slice
            "com.overseas.netbanking",                // Indian Overseas Bank (IOB)
            "com.iob.iobnet",                         // IOB Mobile
            "net.one97.paytm",                        // Paytm
            "com.google.android.apps.nbu.paisa.user", // Google Pay
            "com.phonepe.app"                         // PhonePe
        )
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        if (sbn == null) return

        val packageName = sbn.packageName ?: return
        if (!SUPPORTED_PACKAGES.contains(packageName)) {
            return
        }

        val notification = sbn.notification ?: return
        val extras = notification.extras ?: return

        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        val subText = extras.getCharSequence(Notification.EXTRA_SUB_TEXT)?.toString() ?: ""

        val effectiveText = when {
            bigText.isNotEmpty() -> bigText
            text.isNotEmpty() -> text
            else -> subText
        }

        if (effectiveText.isBlank()) return

        val payload = mapOf(
            "packageName" to packageName,
            "title" to title,
            "text" to effectiveText,
            "subText" to subText,
            "postTime" to sbn.postTime,
            "key" to sbn.key
        )

        Log.d(TAG, "Captured financial notification from $packageName: $title - $effectiveText")
        NotificationStreamHandler.dispatch(payload)
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        super.onNotificationRemoved(sbn)
    }
}
