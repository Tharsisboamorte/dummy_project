import 'dart:convert';

import 'package:dummy_project/core/errors/exceptions.dart';
import 'package:dummy_project/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:dummy_project/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test(
      'should complete successfully when the status code is 200 or 201',
      () async {
        when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User created successfully', 201),
        );

        final methodCall = remoteDataSource.createUser;

        expect(
            methodCall(
              createdAt: 'createdAt',
              name: 'name',
              avatar: 'avatar',
            ),
            completes);

        verify(() => client.post(
              Uri.parse(kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              }),
            )).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw [APIException] when the status code is not 200 or 201',
      () async {
        when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('Invalid email address', 400),
        );
        final methodCall = remoteDataSource.createUser;

        expect(
          () async => methodCall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          throwsA(
            const APIException(
                message: 'Invalid email address', statusCode: 400),
          ),
        );
        verify(() => client.post(
              Uri.parse(kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              }),
            )).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });

  group('getUsers', () {
    final tUsers = [const UserModel.empty()];
    test(
      'should complete successfully when the status code is 200 or 201'
      ' and return a list of Users ',
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
        );

        final result = await remoteDataSource.getUsers();

        expect(result, equals(tUsers));

        verify(() => client.get(Uri.parse(kGetUsersEndpoint))).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw [APIException] when status code is not 200',
      () async {
        const tMessage = 'Server down';
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(tMessage, 500),
        );

        final methodCall = remoteDataSource.getUsers;

        expect(
          () => methodCall(),
          throwsA(const APIException(message: tMessage, statusCode: 500)),
        );
        verify(
          () => client.get(Uri.parse(kGetUsersEndpoint)),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });
}
