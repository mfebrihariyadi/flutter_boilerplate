import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info }

class ToastHelper {
  ToastHelper._();

  static Future<bool?> show({
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return false;
    }

    final trimmedTitle = title?.trim();
    final formattedMessage = trimmedTitle == null || trimmedTitle.isEmpty
        ? trimmedMessage
        : '$trimmedTitle: $trimmedMessage';

    await Fluttertoast.cancel();

    return Fluttertoast.showToast(
      msg: formattedMessage,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: _backgroundColor(type),
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static Future<bool?> showSuccess(String message, {String title = 'Success'}) {
    return show(message: message, type: ToastType.success);
  }

  static Future<bool?> showError(String message, {String title = 'Error'}) {
    return show(message: message, type: ToastType.error);
  }

  static Future<bool?> showInfo(String message, {String title = 'Info'}) {
    return show(message: message, type: ToastType.info);
  }

  static Color _backgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.redAccent;
      case ToastType.info:
        return Colors.blueGrey;
    }
  }
}
