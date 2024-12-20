import 'dart:convert';

import 'package:flutter/services.dart';

enum VpnStatus {
  connecting(code: 0),
  connect(code: 1),
  disconnect(code: 2);

  const VpnStatus({required this.code});

  final int code;
}

class VpnManager {
  String methodChannel = "com.v2ray.ang/method_channel";

  Future<bool> connect(String config) async {
    // Native channel
    final platform = MethodChannel(methodChannel);
    bool result = false;
    try {
      result = await platform.invokeMethod("connect", {'config': config});
    } on PlatformException catch (e) {
      print(e.toString());
      rethrow;
    }
    return result;
  }

  Future<bool> disconnect() async {
    // Native channel
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

  // Future<bool> testCurrentServerRealPing() async {
  //   // Native channel
  //   final platform = MethodChannel(methodChannel);
  //   bool result = false;
  //   try {
  //     result = await platform.invokeMethod("testCurrentServerRealPing");
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  //   return result;
  // }

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
