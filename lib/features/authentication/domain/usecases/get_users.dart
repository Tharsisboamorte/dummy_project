import 'package:dummy_project/core/usecase/usecase.dart';
import 'package:dummy_project/core/utils/typedef.dart';
import 'package:dummy_project/features/authentication/domain/entities/user.dart';
import 'package:dummy_project/features/authentication/domain/repositories/auth_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {
    const GetUsers(this._repository);

    final AuthenticationRepository _repository;

    @override
    ResultFuture<List<User>> call() async => _repository.getUsers();
}