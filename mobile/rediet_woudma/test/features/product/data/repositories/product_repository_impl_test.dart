import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:rediet_woudma/core/error/failure.dart';
import 'package:rediet_woudma/core/network/network_info.dart';
import 'package:rediet_woudma/features/product/data/datasources/product_local_data_source.dart';
import 'package:rediet_woudma/features/product/data/datasources/product_remote_data_source.dart';
import 'package:rediet_woudma/features/product/data/models/product_model.dart';
import 'package:rediet_woudma/features/product/data/repositories/product_repository_impl.dart';
import 'package:rediet_woudma/features/product/domain/entities/product.dart';

class MockRemote extends Mock implements ProductRemoteDataSource {}

class MockLocal extends Mock implements ProductLocalDataSource {}

class MockNet extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repo;
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late MockNet mockNet;

  const tModel = ProductModel(
    id: '1',
    name: 'A',
    description: 'Desc',
    imageUrl: 'url',
    price: 1.0,
  );

  const tProduct = Product(
    id: '1',
    name: 'A',
    description: 'Desc',
    imageUrl: 'url',
    price: 1.0,
  );

  final tModelList = <ProductModel>[tModel];
  const tId = '1';

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    mockNet = MockNet();
    repo = ProductRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNet,
    );
  });

  group('getAllProducts', () {
    test('online → success & caches', () async {
      when(mockNet.isConnected).thenAnswer((_) async => true);
      when(mockRemote.fetchAllProducts()).thenAnswer((_) async => tModelList);

      final result = await repo.getAllProducts();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(identical(list, tModelList), isTrue),
      );

      verify(mockRemote.fetchAllProducts()).called(1);
      verify(mockLocal.cacheProducts(tModelList)).called(1);
    });

    test('online → remote throws → ServerFailure', () async {
      when(mockNet.isConnected).thenAnswer((_) async => true);
      when(mockRemote.fetchAllProducts()).thenThrow(Exception('oops'));

      final result = await repo.getAllProducts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );

      verify(mockRemote.fetchAllProducts()).called(1);
      verifyNever(mockLocal.cacheProducts(tModelList));
    });

    test('offline → returns cache', () async {
      when(mockNet.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProducts()).thenAnswer((_) async => tModelList);

      final result = await repo.getAllProducts();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(identical(list, tModelList), isTrue),
      );

      verify(mockLocal.getCachedProducts()).called(1);
      verifyZeroInteractions(mockRemote);
    });

    test('offline → cache miss → CacheFailure', () async {
      when(mockNet.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProducts()).thenThrow(Exception());

      final result = await repo.getAllProducts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );

      verify(mockLocal.getCachedProducts()).called(1);
      verifyZeroInteractions(mockRemote);
    });
  });

  group('getProductById', () {
    test('online → success & caches', () async {
      when(mockNet.isConnected).thenAnswer((_) async => true);
      when(mockRemote.fetchProductById(tId)).thenAnswer((_) async => tModel);

      final result = await repo.getProductById(tId);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (item) => expect(item, tModel),
      );

      verify(mockRemote.fetchProductById(tId)).called(1);
      verify(mockLocal.cacheProduct(tModel)).called(1);
    });

    test('online → remote throws → ServerFailure', () async {
      when(mockNet.isConnected).thenAnswer((_) async => true);
      when(mockRemote.fetchProductById(tId)).thenThrow(Exception());

      final result = await repo.getProductById(tId);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );

      verify(mockRemote.fetchProductById(tId)).called(1);
      verifyNever(mockLocal.cacheProduct(tModel));
    });

    test('offline → returns cache', () async {
      when(mockNet.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProduct(tId)).thenAnswer((_) async => tModel);

      final result = await repo.getProductById(tId);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (item) => expect(item, tModel),
      );

      verify(mockLocal.getCachedProduct(tId)).called(1);
      verifyZeroInteractions(mockRemote);
    });

    test('offline → cache miss → CacheFailure', () async {
      when(mockNet.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProduct(tId)).thenThrow(Exception());

      final result = await repo.getProductById(tId);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );

      verify(mockLocal.getCachedProduct(tId)).called(1);
      verifyZeroInteractions(mockRemote);
    });
  });

  group('createProduct', () {
    test('calls remote & returns Right(unit)', () async {
      const expected = ProductModel(
        id: '1',
        name: 'A',
        description: 'Desc',
        imageUrl: 'url',
        price: 1.0,
      );
      when(mockRemote.createProduct(expected)).thenAnswer((_) async {});

      final result = await repo.createProduct(tProduct);

      expect(result.isRight(), isTrue);
      expect(result, isA<Right<Failure, Unit>>());
      verify(mockRemote.createProduct(expected)).called(1);
      verifyZeroInteractions(mockLocal);
    });

    test('remote throws → ServerFailure', () async {
      const expected = ProductModel(
        id: '1',
        name: 'A',
        description: 'Desc',
        imageUrl: 'url',
        price: 1.0,
      );
      when(mockRemote.createProduct(expected)).thenThrow(Exception());

      final result = await repo.createProduct(tProduct);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
      verify(mockRemote.createProduct(expected)).called(1);
      verifyZeroInteractions(mockLocal);
    });
  });

  group('updateProduct', () {
    test('calls remote & returns Right(unit)', () async {
      const expected = ProductModel(
        id: '1',
        name: 'A',
        description: 'Desc',
        imageUrl: 'url',
        price: 1.0,
      );
      when(mockRemote.updateProduct(expected)).thenAnswer((_) async {});

      final result = await repo.updateProduct(tProduct);

      expect(result.isRight(), isTrue);
      expect(result, isA<Right<Failure, Unit>>());
      verify(mockRemote.updateProduct(expected)).called(1);
      verifyZeroInteractions(mockLocal);
    });

    test('remote throws → ServerFailure', () async {
      const expected = ProductModel(
        id: '1',
        name: 'A',
        description: 'Desc',
        imageUrl: 'url',
        price: 1.0,
      );
      when(mockRemote.updateProduct(expected)).thenThrow(Exception());

      final result = await repo.updateProduct(tProduct);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
      verify(mockRemote.updateProduct(expected)).called(1);
      verifyZeroInteractions(mockLocal);
    });
  });

  group('deleteProduct', () {
    test('calls remote & returns Right(unit)', () async {
      when(mockRemote.deleteProduct(tId)).thenAnswer((_) async {});

      final result = await repo.deleteProduct(tId);

      expect(result.isRight(), isTrue);
      expect(result, isA<Right<Failure, Unit>>());
      verify(mockRemote.deleteProduct(tId)).called(1);
      verifyNever(mockLocal.cacheProduct(tModel));
    });

    test('remote throws → ServerFailure', () async {
      when(mockRemote.deleteProduct(tId)).thenThrow(Exception('oops'));

      final result = await repo.deleteProduct(tId);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
      verify(mockRemote.deleteProduct(tId)).called(1);
      verifyNever(mockLocal.cacheProduct(tModel));
    });
  });
}
