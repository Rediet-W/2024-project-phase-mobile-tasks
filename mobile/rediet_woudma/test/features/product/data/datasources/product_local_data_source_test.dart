import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rediet_woudma/core/error/exception.dart';
import 'package:rediet_woudma/features/product/data/datasources/product_local_data_source.dart';
import 'package:rediet_woudma/features/product/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getCachedProducts', () {
    const tModels = [
      ProductModel(
          id: '1', name: 'A', description: 'd', imageUrl: 'u', price: 1.0),
      ProductModel(
          id: '2', name: 'B', description: 'd', imageUrl: 'u2', price: 2.0),
    ];
    final jsonString = json.encode(tModels.map((p) => p.toJson()).toList());

    test('should return list of products when there is a cached value',
        () async {
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(jsonString);

      final result = await dataSource.getCachedProducts();

      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS));
      expect(result, equals(tModels));
    });

    test('should throw CacheException when there is no cached value', () {
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(null);

      final call = dataSource.getCachedProducts;
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheProducts', () {
    const tModels = [
      ProductModel(
          id: '1', name: 'A', description: 'd', imageUrl: 'u', price: 1.0),
    ];

    test('should call SharedPreferences to cache the list', () {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(null);
      dataSource.cacheProducts(tModels);

      final expectedJson = json.encode(tModels.map((p) => p.toJson()).toList());
      verify(() => mockSharedPreferences.setString(
            CACHED_PRODUCTS,
            expectedJson,
          )).called(1);
    });
  });

  group('cacheProduct', () {
    const tModel = ProductModel(
        id: '3', name: 'C', description: 'c', imageUrl: 'u3', price: 3.0);

    test('should add product to empty cache', () {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(null);

      dataSource.cacheProduct(tModel);

      final expectedJson = json.encode([tModel.toJson()]);
      verify(() => mockSharedPreferences.setString(
            CACHED_PRODUCTS,
            expectedJson,
          )).called(1);
    });

    test('should replace existing product if ID matches', () {
      const existing = ProductModel(
          id: '3', name: 'Old', description: 'o', imageUrl: 'u0', price: 0.5);
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(json.encode([existing.toJson()]));

      dataSource.cacheProduct(tModel);

      final expectedJson = json.encode([tModel.toJson()]);
      verify(() => mockSharedPreferences.setString(
            CACHED_PRODUCTS,
            expectedJson,
          )).called(1);
    });
  });

  group('getCachedProduct', () {
    const tModels = [
      ProductModel(
          id: '1', name: 'A', description: 'd', imageUrl: 'u', price: 1.0),
      ProductModel(
          id: '2', name: 'B', description: 'd', imageUrl: 'u2', price: 2.0),
    ];
    final jsonString = json.encode(tModels.map((p) => p.toJson()).toList());

    test('should return product when it exists in cache', () async {
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(jsonString);

      final result = await dataSource.getCachedProduct('2');

      verify(() => mockSharedPreferences.getString(CACHED_PRODUCTS));
      expect(result, equals(tModels[1]));
    });

    test('should throw CacheException when product not found', () {
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(jsonString);

      final call = () => dataSource.getCachedProduct('3');
      expect(call, throwsA(const TypeMatcher<CacheException>()));
    });

    test('should throw CacheException when no cache present', () {
      when(() => mockSharedPreferences.getString(CACHED_PRODUCTS))
          .thenReturn(null);

      final call = () => dataSource.getCachedProduct('1');
      expect(call, throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
