import 'package:get_it/get_it.dart';
import 'package:exemplo/data/database/database_factory.dart';
import 'package:exemplo/data/database/database_factory_provider.dart';
import 'package:exemplo/data/database/database_provider.dart';
import 'package:exemplo/data/daos/pessoa_dao.dart';
import 'package:exemplo/domain/repositories/pessoa_repository.dart';
import 'package:exemplo/data/repositories/pessoa_repository_impl.dart';
import 'package:exemplo/presentation/stores/pessoa_store.dart';

class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> setup() async {
    _getIt.registerLazySingleton<AppDatabaseFactory>(
      () => DatabaseFactoryProvider.create(),
    );

    _getIt.registerLazySingleton<DatabaseProvider>(
      () => DatabaseProvider(_getIt<AppDatabaseFactory>()),
    );

    final databaseProvider = _getIt<DatabaseProvider>();
    final database = await databaseProvider.getDatabase();

    _getIt.registerLazySingleton<PessoaDao>(() => PessoaDao(database));

    _getIt.registerLazySingleton<PessoaRepository>(
      () => PessoaRepositoryImpl(_getIt<PessoaDao>()),
    );

    _getIt.registerLazySingleton<PessoaStore>(
      () => PessoaStore(_getIt<PessoaRepository>()),
    );
  }

  static T get<T extends Object>() => _getIt<T>();

  static bool isRegistered<T extends Object>() => _getIt.isRegistered<T>();

  static Future<void> reset() async {
    await _getIt.reset();
  }

  static Future<void> dispose() async {
    if (isRegistered<DatabaseProvider>()) {
      await get<DatabaseProvider>().close();
    }
    if (isRegistered<PessoaStore>()) {
      get<PessoaStore>().dispose();
    }
  }
}
