// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Геттеры для доступа к сервисам
  FirebaseAuth get auth => _auth;
  FirebaseDatabase get database => _database;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseMessaging get messaging => _messaging;

  // Инициализация Firebase
  Future<void> initialize() async {
    try {
      debugPrint('Initializing Firebase services...');
      
      // Настройка Firebase Messaging
      await _setupMessaging();
      debugPrint('Messaging setup completed');
      
      debugPrint('Firebase services initialization completed successfully');
    } catch (e, stackTrace) {
      debugPrint('Error initializing Firebase services: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Настройка Firebase Messaging
  Future<void> _setupMessaging() async {
    try {
      debugPrint('Setting up Firebase Messaging...');
      // Запрос разрешений на уведомления
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Получение FCM токена
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');

      // Обработка сообщений в фоновом режиме
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Обработка сообщений в активном режиме
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint('Message also contained a notification: ${message.notification}');
        }
      });
      
      debugPrint('Firebase Messaging setup completed');
    } catch (e, stackTrace) {
      debugPrint('Error setting up Firebase Messaging: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

// Обработчик фоновых сообщений
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // Инициализация Firebase Core, только если он еще не инициализирован в этом изоляте
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
       debugPrint('Firebase Core initialized in background handler');
    } else {
      debugPrint('Firebase Core already initialized in background handler');
    }
    debugPrint('Handling a background message: ${message.messageId}');
  } catch (e, stackTrace) {
    debugPrint('Error handling background message: $e');
    debugPrint('Stack trace: $stackTrace');
  }
} 