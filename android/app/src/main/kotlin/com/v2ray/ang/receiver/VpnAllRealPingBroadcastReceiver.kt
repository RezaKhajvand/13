package com.v2ray.ang.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class VpnAllRealPingBroadcastReceiver : BroadcastReceiver() {
    private lateinit var callback: VpnAllRealPingListener

    fun setListener(callback: VpnAllRealPingListener) {
        this.callback = callback;
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent != null) {
            if (intent.action == "action.VPN_ALL_REAL_PING") {
                val info = intent.getSerializableExtra("vpn_all_real_ping") as Pair<String, Long>
                if (info != null)
                    callback.onVpnAllRealPingRequest(info)
            }
        }
    }
}

interface  VpnAllRealPingListener {
    fun onVpnAllRealPingRequest(ping: Pair<String, Long>) {}
}