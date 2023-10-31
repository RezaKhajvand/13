package com.v2ray.ang.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class VpnPingBroadcastReceiver : BroadcastReceiver() {
    private lateinit var callback: VpnPingListener

    fun setListener(callback: VpnPingListener) {
        this.callback = callback;
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent != null) {
            if (intent.action == "action.VPN_PING") {
                val info = intent.getStringExtra("vpn_ping")
                if (info != null)
                    callback.onVpnPingRequest(info)
            }
        }
    }
}

interface VpnPingListener {
    fun onVpnPingRequest(ping: String)
}