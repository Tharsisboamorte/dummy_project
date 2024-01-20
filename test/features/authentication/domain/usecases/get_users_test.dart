import 'package:dartz/dartz.dart';
import 'package:dummy_project/features/authentication/domain/entities/user.dart';
import 'package:dummy_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dummy_project/features/authentication/domain/usecases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(repository);
  });

  const tResponse = [User.empty()];

  test(
    'should call the [AuthRepo.getUsers] and return [List<User>]',
    () async {
      //Arrange
      when(() => repository.getUsers())
          .thenAnswer((_) async => const Right(tResponse));
      //Act
      final result = await usecase();

      expect(result, equals(const Right<dynamic, List<User>>(tResponse)));
      verify(() => repository.getUsers()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
