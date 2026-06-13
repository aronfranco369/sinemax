import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'data/download_engine.dart';
import 'models/library_item.dart';
import 'models/media.dart';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();
  await Supabase.initialize(url: dotenv.env['SUPABASE_URL']!, anonKey: dotenv.env['SUPABASE_ANON_KEY']!);

  await Hive.initFlutter();
  Hive.registerAdapter(WatchedItemAdapter());
  Hive.registerAdapter(DownloadRecordAdapter());
  Hive.registerAdapter(MediaHiveAdapter());
  Hive.registerAdapter(MediaFileHiveAdapter());
  await Future.wait([
    Hive.openBox<bool>('saved'),
    Hive.openBox<WatchedItem>('recent'),
    Hive.openBox<DownloadRecord>('download_records'),
    Hive.openBox<Media>('media_cache'),
    Hive.openBox<MediaFile>('files_cache'),
    Hive.openBox<bool>('files_fetched'),
    Hive.openBox<String>('metadata'),
    Hive.openBox<String>('recent_searches'),
  ]);

  // Offline downloads: notifications, task tracking, AES key, reconcile state.
  await DownloadEngine.instance.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A1628),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: SinemaxApp()));
}
