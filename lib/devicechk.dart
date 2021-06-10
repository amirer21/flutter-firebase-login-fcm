import 'dart:async';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';

  String _deviceId;
  String _deviceOs;

  Future<void> initPlatformState2() async {
    String deviceId;
    String deviceOs;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      deviceOs = await PlatformDeviceId.getDeviceOS;
      print("Device Check : "+deviceOs);
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
  }

