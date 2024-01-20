import 'dart:convert';
import 'dart:io';

import 'package:dummy_project/core/utils/typedef.dart';
import 'package:dummy_project/features/authentication/data/models/user_model.dart';
import 'package:dummy_project/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test('should be a subclass of [User] entity', () {
    //Act

    //Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with the correct data', () {
      //Arrange

      //Act
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
      //Assert
    });
  });

  group('fromJson', () {
    test('should return a [UserModel] with the correct data', () {
      //Arrange

      //Act
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
      //Assert
    });
  });

  group('toMap', () {
    test('should return a [Map] with the right data', () {
      //Act
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [JSON] with the right data', () {
      //Act
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": "1",
        "createdAt": "_empty.createdAt",
        "avatar": "_empty.avatar",
        "name": "_empty.name"
      });
      expect(result, tJson);
    });
  });

  group('copyWith', () {
    test('should return [UserModel] with different data', () {
      final result = tModel.copyWith(name: 'Paul');

      expect(result.name, equals('Paul'));
    });
  });
}
