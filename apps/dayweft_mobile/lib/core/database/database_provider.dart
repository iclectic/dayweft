import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dayweftDatabaseProvider = Provider<DayweftDatabase>((ref) {
  final database = DayweftDatabase();
  ref.onDispose(database.close);
  return database;
});
