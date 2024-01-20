import 'package:dummy_project/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:dummy_project/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:dummy_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dummy_project/features/authentication/domain/usecases/create_user.dart';
import 'package:dummy_project/features/authentication/domain/usecases/get_users.dart';
import 'package:dummy_project/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    //App Logic
    ..registerFactory(() => AuthCubit(
          createUser: sl(),
          getUsers: sl(),
        ))
    //Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    //Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthRepositoryImpl(sl()))

    //Data Sources
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSrcImpl(sl()))

    //External Dependencies
    ..registerLazySingleton(http.Client.new);
}
