import 'package:drift/native.dart';
import 'package:fooddrop/core/db/app_database.dart';

AppDatabase openTestDatabase() => AppDatabase(NativeDatabase.memory());
