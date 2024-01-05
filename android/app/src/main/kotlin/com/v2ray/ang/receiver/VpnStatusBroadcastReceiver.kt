package com.v2ray.ang.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class VpnStatusBroadcastReceiver : BroadcastReceiver() {
    private var callback: VpnStatusListener? = null

    fun setListener(callback: VpnStatusListener?) {
        this.callback = callback;
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent != null) {
            if (intent.action == "action.VPN_STATUS") {
                val info = intent.getIntExtra("vpn_status", 2)
                if (callback != null)
                    callback!!.onVpnStatusChange(info)
            }
        }
    }
}

interface VpnStatusListener {
    fun onVpnStatusChange(status: Int)
}