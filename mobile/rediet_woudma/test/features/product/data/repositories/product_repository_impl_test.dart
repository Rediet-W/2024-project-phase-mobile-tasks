import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rediet_woudma/core/error/failure.dart';
import 'package:rediet_woudma/core/network/network_info.dart';
import 'package:rediet_woudma/features/product/data/datasources/product_local_data_source.dart';
import 'package:rediet_woudma/features/product/data/datasources/product_remote_data_source.dart';
import 'package:rediet_woudma/features/product/data/models/product_model.dart';
import 'package:rediet_woudma/features/product/data/repositories/product_repository_impl.dart';
import 'package:rediet_woudma/features/product/domain/entities/product.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

class MockProductLocalDataSource extends Mock
    implements ProductLocalDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockInternetConnectionChecker mockChecker;
  late MockNetworkInfo mockNetworkInfo;
  late MockProductRemoteDataSource mockRemote;
  late MockProductLocalDataSource mockLocal;

  setUp(() {
    registerFallbackValue(const ProductModel(
      id: 'fallback',
      name: 'fallback',
      description: 'fallback',
      imageUrl: 'fallback',
      price: 0.0,
    ));
    mockChecker = MockInternetConnectionChecker();
    mockNetworkInfo = MockNetworkInfo();
    mockRemote = MockProductRemoteDataSource();
    mockLocal = MockProductLocalDataSource();

    repository = ProductRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllProducts', () {
    const tModels = [
      ProductModel(
          id: '1', name: 'A', description: 'd', imageUrl: 'u', price: 1.0),
      ProductModel(
          id: '2', name: 'B', description: 'd', imageUrl: 'u2', price: 2.0),
    ];
    const List<Product> tProducts = tModels;

    test('online & remote success → caches & returns data', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.fetchAllProducts())
          .thenAnswer((_) async => tModels);
      when(() => mockLocal.cacheProducts(tModels)).thenAnswer((_) async {});
      final result = await repository.getAllProducts();

      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemote.fetchAllProducts()).called(1);
      verify(() => mockLocal.cacheProducts(tModels)).called(1);
      expect(result, equals(const Right(tProducts)));
    });

    test('online & remote throws → returns ServerFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.fetchAllProducts()).thenThrow(Exception('oops'));

      final result = await repository.getAllProducts();

      verify(() => mockRemote.fetchAllProducts()).called(1);
      verifyNever(() => mockLocal.cacheProducts(any()));
      expect(result, equals(Left(ServerFailure('Exception: oops'))));
    });

    test('offline & cache success → returns cached data', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedProducts())
          .thenAnswer((_) async => tModels);

      final result = await repository.getAllProducts();

      verifyNever(() => mockRemote.fetchAllProducts());
      verify(() => mockLocal.getCachedProducts()).called(1);
      expect(result, equals(const Right(tProducts)));
    });

    test('offline & cache throws → returns CacheFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedProducts()).thenThrow(Exception());

      final result = await repository.getAllProducts();

      verify(() => mockLocal.getCachedProducts()).called(1);
      expect(result, equals(const Left(CacheFailure())));
    });
  });

  group('getProductById', () {
    const tId = '42';
    const tModel = ProductModel(
        id: tId, name: 'X', description: 'd', imageUrl: 'u', price: 9.99);
    const Product tProduct = tModel;

    test('online & remote success → caches & returns product', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.fetchProductById(tId))
          .thenAnswer((_) async => tModel);
      when(() => mockLocal.cacheProduct(tModel)).thenAnswer((_) async {});

      final result = await repository.getProductById(tId);

      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemote.fetchProductById(tId)).called(1);
      verify(() => mockLocal.cacheProduct(tModel)).called(1);
      expect(result, equals(const Right(tProduct)));
    });

    test('online & remote throws → returns ServerFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.fetchProductById(tId)).thenThrow(Exception('fail'));

      final result = await repository.getProductById(tId);

      verify(() => mockRemote.fetchProductById(tId)).called(1);
      verifyNever(() => mockLocal.cacheProduct(any()));
      expect(result, equals(Left(ServerFailure('Exception: fail'))));
    });

    test('offline & cache success → returns cached product', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedProduct(tId))
          .thenAnswer((_) async => tModel);

      final result = await repository.getProductById(tId);

      verifyNever(() => mockRemote.fetchProductById(any()));
      verify(() => mockLocal.getCachedProduct(tId)).called(1);
      expect(result, equals(const Right(tProduct)));
    });

    test('offline & cache throws → returns CacheFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocal.getCachedProduct(tId)).thenThrow(Exception());

      final result = await repository.getProductById(tId);

      verify(() => mockLocal.getCachedProduct(tId)).called(1);
      expect(result, equals(const Left(CacheFailure())));
    });
  });

  group('createProduct', () {
    const tEntity = Product(
        id: '9', name: 'New', description: 'd', imageUrl: 'u', price: 5.0);
    const tModel = ProductModel(
        id: '9', name: 'New', description: 'd', imageUrl: 'u', price: 5.0);

    test('remote success → returns Right(unit)', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.createProduct(tModel)).thenAnswer((_) async {});

      final result = await repository.createProduct(tEntity);

      verify(() => mockRemote.createProduct(tModel)).called(1);
      expect(result, equals(const Right(unit)));
    });

    test('remote throws → returns ServerFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.createProduct(tModel)).thenThrow(Exception('fail'));

      final result = await repository.createProduct(tEntity);

      verify(() => mockRemote.createProduct(tModel)).called(1);
      expect(result, equals(Left(ServerFailure('Exception: fail'))));
    });
  });

  group('updateProduct', () {
    const tEntity = Product(
        id: '9', name: 'Up', description: 'd', imageUrl: 'u', price: 7.0);
    const tModel = ProductModel(
        id: '9', name: 'Up', description: 'd', imageUrl: 'u', price: 7.0);

    test('remote success → returns Right(unit)', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.updateProduct(tModel)).thenAnswer((_) async {});

      final result = await repository.updateProduct(tEntity);

      verify(() => mockRemote.updateProduct(tModel)).called(1);
      expect(result, equals(const Right(unit)));
    });

    test('remote throws → returns ServerFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.updateProduct(tModel)).thenThrow(Exception('fail'));

      final result = await repository.updateProduct(tEntity);

      verify(() => mockRemote.updateProduct(tModel)).called(1);
      expect(result, equals(Left(ServerFailure('Exception: fail'))));
    });
  });

  group('deleteProduct', () {
    const tId = '9';

    test('remote success → returns Right(unit)', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.deleteProduct(tId)).thenAnswer((_) async {});

      final result = await repository.deleteProduct(tId);

      verify(() => mockRemote.deleteProduct(tId)).called(1);
      expect(result, equals(const Right(unit)));
    });

    test('remote throws → returns ServerFailure', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.deleteProduct(tId)).thenThrow(Exception('fail'));

      final result = await repository.deleteProduct(tId);

      verify(() => mockRemote.deleteProduct(tId)).called(1);
      expect(result, equals(Left(ServerFailure('Exception: fail'))));
    });
  });
}
