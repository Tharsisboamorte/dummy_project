import 'package:dartz/dartz.dart';
import 'package:dummy_project/core/errors/exceptions.dart';
import 'package:dummy_project/core/errors/failure.dart';
import 'package:dummy_project/core/utils/typedef.dart';
import 'package:dummy_project/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:dummy_project/features/authentication/domain/entities/user.dart';
import 'package:dummy_project/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthenticationRepository {
  //Dependency inversion
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // TDD
    // call the remote data source
    // make sure that it returns the proper data if there is no exception
    // check if the method return the proper data
    // check if when the remoteDataSource throws an exception, we return a
    // failure and if it doesn't throw an exception, we return the actual
    // expected data

    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
