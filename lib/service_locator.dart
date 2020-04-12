import 'package:get_it/get_it.dart';
import 'package:todonick/services/auth_service.dart';
import 'package:todonick/services/database_service.dart';
import 'package:todonick/services/storage_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(AuthService());
  locator.registerSingleton(DatabaseService());
  locator.registerSingleton(StorageService());
}
