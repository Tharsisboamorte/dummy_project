import 'package:dartz/dartz.dart';
import 'package:dummy_project/core/errors/exceptions.dart';
import 'package:dummy_project/core/errors/failure.dart';
import 'package:dummy_project/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:dummy_project/features/authentication/data/models/user_model.dart';
import 'package:dummy_project/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:dummy_project/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSrc extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl repositoryImpl;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repositoryImpl = AuthRepositoryImpl(remoteDataSource);
  });

  const tException = APIException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  group(
    'createUser',
    () {
      const createdAt = 'new_createdAt';
      const name = 'new_name';
      const avatar = 'new_avatar';
      test(
        'should call the [RemoteDataSource.createUser] and complete '
        'successfully when the call to the remote source is successful',
        () async {
          // arrange
          when(() => remoteDataSource.createUser(
                createdAt: any(named: 'createdAt'),
                name: any(named: 'name'),
                avatar: any(named: 'avatar'),
              )).thenAnswer((_) async => Future.value());

          //act
          final result = await repositoryImpl.createUser(
              createdAt: createdAt, name: name, avatar: avatar);

          //assert
          expect(result, equals(const Right(null)));
          verify(() => remoteDataSource.createUser(
                createdAt: createdAt,
                name: name,
                avatar: avatar,
              )).called(1);
        },
      );

      test(
        'should return a [APIFailure] when the call to the remote '
        'source is unsuccessful',
        () async {
          //Arrange
          when(
            () => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
            ),
          ).thenThrow(tException);

          //Act
          final result = await repositoryImpl.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          );

          //Assert
          expect(
            result,
            equals(
              Left(
                APIFailure(
                  message: tException.message,
                  statusCode: tException.statusCode,
                ),
              ),
            ),
          );

          verify(() => remoteDataSource.createUser(
                createdAt: createdAt,
                name: name,
                avatar: avatar,
              )).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );

  group(
    'getUsers',
    () {
      test(
        'should call the [RemoteDataSource.getUsers] and return [List<User>]'
        'when call to remote source if successful',
        () async {
          // arrange
          when(() => remoteDataSource.getUsers()).thenAnswer(
            (_) async => [],
          );

          //act
          final result = await repositoryImpl.getUsers();

          //assert
          expect(result, isA<Right<dynamic, List<User>>>());
          verify(() => remoteDataSource.getUsers()).called(1);
        },
      );

      test(
        'should return a [APIFailure] when the call to the remote '
        'source is unsuccessful',
        () async {
          //Arrange
          when(() => remoteDataSource.getUsers()).thenThrow(tException);

          //Act
          final result = await repositoryImpl.getUsers();

          //Assert
          expect(
            result,
            equals(
              Left(
                APIFailure(
                  message: tException.message,
                  statusCode: tException.statusCode,
                ),
              ),
            ),
          );

          verify(() => remoteDataSource.getUsers()).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );
}
