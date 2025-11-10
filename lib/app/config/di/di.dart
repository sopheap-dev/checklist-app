import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checklist_app/app/core/services/storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt
    ..registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    )
    ..registerSingletonAsync<StorageService>(
      () async => StorageService(await getIt.getAsync<SharedPreferences>()),
    );
}
