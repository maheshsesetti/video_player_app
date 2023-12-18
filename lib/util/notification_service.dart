import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io' show Directory, Platform;

import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart' as path;
final dio = Dio();
class NotificationService {
  final url =
      "http://d5638c46e9d8a6fde200-4a368be6a86dae998dd81c519d69c3f4.r88.cf1.rackcdn.com/AEE7CBFD-66CB-2E17-53B1-81D3882C5F5D.mp4";

  //Android notification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('app_icon');
  // Ios notification plugin

  final IOSFlutterLocalNotificationsPlugin iosFlutterLocalNotificationsPlugin =
      IOSFlutterLocalNotificationsPlugin();
  final DarwinInitializationSettings darwinInitializationSettings =
      const DarwinInitializationSettings();

  Future<void> initialiseNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } else if (Platform.isIOS) {
      await iosFlutterLocalNotificationsPlugin
          .initialize(darwinInitializationSettings);
    }
  }

  Future<void> createNotification(
      int progress, String title, String url) async {
    // var attachmentVideoPath = await downloadFile(url);
    // var bigPictureStyleInformation = BigPictureStyleInformation(
    //   FilePathAndroidBitmap(attachmentVideoPath),
    // );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('basic_channel', 'basic_name',
            channelDescription: 'Flutter local notification package example',
            progress: progress,
            maxProgress: 100,
            onlyAlertOnce: true,
            importance: Importance.high,
            playSound: true,
            ledColor: Colors.white,
            ledOnMs: 30,
            ledOffMs: 20,
            channelShowBadge: true,
            // largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            // styleInformation: bigPictureStyleInformation
        );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentSound: true,
        //     attachments: [
        //   // DarwinNotificationAttachment(attachmentVideoPath),
        // ]
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        '${progress.toString()}% completed',
        notificationDetails,
        payload: 'Download in progress',
      );
    } else if (Platform.isIOS) {
      await iosFlutterLocalNotificationsPlugin.show(
        0,
        title,
        '${progress.toString()}% completed',
        notificationDetails: darwinNotificationDetails,
        payload: 'Download in progress',
      );
    }
  }

  downloadFile(String url) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/Video.mp4';

    await dio.download(url, filePath,
        onReceiveProgress: (received, total) {
      final progress = (received / total) * 100;
      createNotification(progress.toInt(), 'Download in progress', url);
    });
  }

  Future<void> stopNotification() async {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.cancel(0);
    } else if (Platform.isIOS) {
      iosFlutterLocalNotificationsPlugin.cancel(0);
    }
  }
}
