import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checklist_app/app/core/services/storage_service.dart';
import 'package:checklist_app/data/repo/checklist_repo.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt
    ..registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    )
    ..registerSingletonAsync<StorageService>(
      () async => StorageService(await getIt.getAsync<SharedPreferences>()),
    )
    ..registerSingletonAsync<ChecklistRepository>(() async {
      final repository = ChecklistRepositoryImpl();
      await repository.init();
      return repository;
    });

  await getIt.allReady();
}
