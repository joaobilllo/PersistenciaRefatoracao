import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:exemplo/data/database/database_factory.dart';
import 'package:exemplo/data/database/mobile_database_factory.dart';
import 'package:exemplo/data/database/desktop_database_factory.dart';
import 'package:exemplo/data/database/web_database_factory.dart';

class DatabaseFactoryProvider {
  static AppDatabaseFactory create() {
    if (kIsWeb) {
      return WebDatabaseFactory();
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return DesktopDatabaseFactory();
    } else {
      return MobileDatabaseFactory();
    }
  }
}
