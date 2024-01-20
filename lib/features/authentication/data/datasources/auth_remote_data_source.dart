import 'dart:convert';

import 'package:dummy_project/core/errors/exceptions.dart';
import 'package:dummy_project/core/utils/constants.dart';
import 'package:dummy_project/core/utils/typedef.dart';
import 'package:dummy_project/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = "$kBaseUrl/test-api/users";
const kGetUsersEndpoint = "$kBaseUrl/test-api/users";

class AuthRemoteDataSrcImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // 1. check to make sure that it returns the right data when the status
    // code is 200 or proper response code
    // 2. check to make sure that it "THROWS A CUSTOM EXCEPTION" with the
    // right message when status code is the bad one
    try {
      final response = await _client.post(
        Uri.parse(kCreateUserEndpoint),
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
        }),
        headers: {
          'Content-type': 'application/json'
        }
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try{
      final response = await _client.get(Uri.parse(kGetUsersEndpoint));

      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
