import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:is_lock_screen/is_lock_screen.dart';

import 'local_notification.dart';

class AppNotification {
  ///when ever the user opens the app by tapping on the push notification
  ///then corresponding page should be opened
  static final List<String> channels = ["basic_channel", "emergency_channels"];
  static Future<void> bacgroundMessage(RemoteMessage message) async {
    debugPrint("Notification recived");
    if (message.notification == null) {
      createNotification(LocalNotification.fromJson(message.data));
    }
  }

  static void listenForMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Notification recived");
      if (message.notification == null) {
        debugPrint("Creating notification");
        final messageData = LocalNotification.fromJson(message.data);

        createNotification(messageData);
      }
    });
  }

  static Future<void> onAction(ReceivedAction event) async {
    if (event.payload != null) {
      final action = AppNotification.getButtonAction(event);

      if (action != null) {
        AppNotification.performAction(action);
      }
    }
  }

  static Future<void> init() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    await awesomeNotifications.initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: channels[0],
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              channelShowBadge: true,
              ledColor: Colors.white),
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: channels[1],
              channelName: 'Emergency Notification',
              channelDescription: 'Notification channel Emergenecy help',
              defaultColor: const Color.fromARGB(255, 236, 29, 29),
              enableVibration: true,
              importance: NotificationImportance.Max,
              soundSource: "resource://raw/sound",
              channelShowBadge: true,
              onlyAlertOnce: false,
              ledColor: Colors.red)
        ],
        debug: true);
  }

  static createNotification(LocalNotification notification) async {
    List<NotificationActionButton> buttons = [];

    for (NotificationButton button in notification.buttons) {
      buttons.add(NotificationActionButton(
          key: button.key ?? "",
          label: button.label ?? "",
          autoDismissible: true,
          actionType: ActionType.Default,
          isDangerousOption: button.isDangerousOption ?? false,
          color: button.color == null
              ? null
              : Color(int.parse(button.color!, radix: 16))));
    }

    //bool? result = await isLockScreen();
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          // customSound:
          //     result == null || !result ? null : "resource://raw/sound",
          fullScreenIntent: notification.fullScreenIntent,
          wakeUpScreen: true,
          bigPicture: notification.bigPicture,
          id: notification.notificationId,
          largeIcon: notification.largeIcon,
          // channelKey: result == null || !result
          //     ? notification.channelKey
          //     : "basic_channel",
          channelKey: notification.channelKey,
          title: notification.title,
          payload: {
            "buttons":
                jsonEncode(notification.buttons.map((e) => e.toJson()).toList())
          },
          color: notification.color == null
              ? null
              : Color(int.parse(notification.color!, radix: 16)),
          backgroundColor: notification.backgroundColor == null
              ? null
              : Color(int.parse(notification.backgroundColor!, radix: 16)),
          body: notification.body,
          category: notification.category,
        ),
        actionButtons: buttons);
  }

  static ButtonAction? getButtonAction(ReceivedAction action) {
    if (action.payload!["buttons"] != null &&
        action.payload!["buttons"] is String) {
      final List decode = json.decode(action.payload!["buttons"]!);
      final buttons =
          decode.map((e) => NotificationButton.fromJson(e)).toList();

      NotificationButton? selectedbutton;

      for (var button in buttons) {
        if (button.key == action.buttonKeyPressed) {
          selectedbutton = button;
          break;
        }
      }

      return selectedbutton?.action;
    }
    return null;
  }

  static void performAction(ButtonAction a) {}
}
