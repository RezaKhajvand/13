import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class VpnPingProvider extends ChangeNotifier {
  String _ping = "Test!?";

  String get ping => _ping;

  String pingEventChannel = "com.v2ray.ang/ping_event_channel";

  VpnPingProvider() {
    handleVpnPingChanges();
  }

  void handleVpnPingChanges() {
    final EventChannel stream = EventChannel(pingEventChannel);
    stream.receiveBroadcastStream().listen(
      (data) {
        _ping = data;
        // Fluttertoast.showToast(
        //   msg: '$_vpnStatus',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
        notifyListeners();
      },
    );
  }
}
