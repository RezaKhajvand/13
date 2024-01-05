import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:vpn/hivemodel/hiveconfig.dart';

enum VpnStatus {
  connecting(code: 0),
  connect(code: 1),
  disconnect(code: 2);

  const VpnStatus({required this.code});

  final int code;
}

class VpnManager {
  final hiveConfig = Hive.box<HiveConfig>('configbox');
  String methodChannel = "com.v2ray.ang/method_channel";

  Future<bool> connect() async {
    // Native channel
    final platform = MethodChannel(methodChannel);
    bool result = false;
    var clickedConfig = hiveConfig.values
        .toList()
        .where((element) => element.isclicked == true)
        .first;
    try {
      result = await platform
          .invokeMethod("connect", {'config': clickedConfig.link});
    } on PlatformException catch (e) {
      print(e.toString());
      rethrow;
    }
    return result;
  }

  Future<bool> disconnect() async {
    final platform = MethodChannel(methodChannel);
    bool result = false;
    try {
      result = await platform.invokeMethod("disconnect");
    } on PlatformException catch (e) {
      print(e.toString());
      rethrow;
    }
    return result;
  }

  void testAllRealPing(List<String> configs) async {
    // Native channel
    final platform = MethodChannel(methodChannel);
    try {
      final res = jsonEncode(configs);
      await platform.invokeMethod("testAllRealPing", {'configs': res});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
