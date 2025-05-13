import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:rediet_woudma/core/error/exception.dart';
import 'package:rediet_woudma/features/product/data/datasources/product_remote_data_source.dart';
import 'package:rediet_woudma/features/product/data/models/product_model.dart';

class _FakeUri extends Fake implements Uri {}

class FakeBaseRequest extends Fake implements http.BaseRequest {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late http.Client mockClient;

  const baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  setUpAll(() {
    registerFallbackValue(_FakeUri());
    registerFallbackValue(FakeBaseRequest());
  });

  setUp(() {
    mockClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockClient);
  });

  group('fetchAllProducts', () {
    const tModels = [
      ProductModel(
          id: '1', name: 'A', description: 'd', imageUrl: 'u', price: 1.0),
      ProductModel(
          id: '2', name: 'B', description: 'd', imageUrl: 'u2', price: 2.0),
    ];
    final tJsonBody = json.encode({
      'statusCode': 200,
      'message': '',
      'data': tModels.map((m) => m.toJson()).toList(),
    });

    test('returns list of models on HTTP 200', () async {
      when(() => mockClient.get(
            any<Uri>(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(tJsonBody, 200));

      final result = await dataSource.fetchAllProducts();

      expect(result, equals(tModels));
      verify(() => mockClient.get(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'},
          )).called(1);
    });

    test('throws ServerException on non-200', () async {
      when(() => mockClient.get(any<Uri>(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Error', 404));

      expect(
        () => dataSource.fetchAllProducts(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('fetchProductById', () {
    const tId = '42';
    const tModel = ProductModel(
      id: tId,
      name: 'X',
      description: 'd',
      imageUrl: 'u',
      price: 9.99,
    );
    final tJsonBody = json.encode({
      'statusCode': 200,
      'message': '',
      'data': tModel.toJson(),
    });

    test('returns model for HTTP 200', () async {
      when(() => mockClient.get(
            any<Uri>(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(tJsonBody, 200));

      final result = await dataSource.fetchProductById(tId);

      expect(result, equals(tModel));
      verify(() => mockClient.get(
            Uri.parse('$baseUrl/$tId'),
            headers: {'Content-Type': 'application/json'},
          )).called(1);
    });

    test('throws ServerException on error', () async {
      when(() => mockClient.get(any<Uri>(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => dataSource.fetchProductById(tId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('createProduct', () {
    const tModel = ProductModel(
      id: '9',
      name: 'New',
      description: 'd',
      imageUrl: 'u',
      price: 5.0,
    );

    test('succeeds when server returns 200/201', () async {
      when(() => mockClient.send(any())).thenAnswer((_) async =>
          http.StreamedResponse(Stream.fromIterable([utf8.encode('')]), 201));

      await dataSource.createProduct(tModel, image: null);
      verify(() => mockClient.send(any())).called(1);
    });

    test('throws ServerException on failure', () async {
      when(() => mockClient.send(any())).thenAnswer((_) async =>
          http.StreamedResponse(Stream.fromIterable([utf8.encode('')]), 500));

      expect(
        () => dataSource.createProduct(tModel, image: null),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('updateProduct', () {
    const tModel = ProductModel(
      id: '9',
      name: 'Up',
      description: 'd',
      imageUrl: 'u',
      price: 7.0,
    );

    test('succeeds on HTTP 200', () async {
      when(() => mockClient.put(
            any<Uri>(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('', 200));

      await dataSource.updateProduct(tModel);
      verify(() => mockClient.put(
            Uri.parse('$baseUrl/${tModel.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': tModel.name,
              'description': tModel.description,
              'price': tModel.price,
            }),
          )).called(1);
    });

    test('throws ServerException on non-200', () async {
      when(() => mockClient.put(
            any<Uri>(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Error', 400));

      expect(
        () => dataSource.updateProduct(tModel),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('deleteProduct', () {
    const tId = '9';

    test('succeeds on HTTP 200', () async {
      when(() => mockClient.delete(
            any<Uri>(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('', 200));

      await dataSource.deleteProduct(tId);
      verify(() => mockClient.delete(
            Uri.parse('$baseUrl/$tId'),
            headers: {'Content-Type': 'application/json'},
          )).called(1);
    });

    test('throws ServerException on failure', () async {
      when(() => mockClient.delete(any<Uri>(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => dataSource.deleteProduct(tId),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

class MockClient extends Mock implements http.Client {}
