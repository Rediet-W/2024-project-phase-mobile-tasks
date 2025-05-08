import 'package:flutter_test/flutter_test.dart';
import 'package:rediet_woudma/features/product/data/models/product_model.dart';
import 'package:rediet_woudma/features/product/domain/entities/product.dart';

void main() {
  const tProductModel = ProductModel(
    id: '123',
    name: 'Coffee Mug',
    description: 'A mug for coffee.',
    imageUrl: 'https://example.com/mug.png',
    price: 9.99,
  );

  final tProductJson = {
    'id': '123',
    'name': 'Coffee Mug',
    'description': 'A mug for coffee.',
    'imageUrl': 'https://example.com/mug.png',
    'price': 9.99,
  };

  test('should be a subclass of Product entity', () {
    expect(tProductModel, isA<Product>());
  });

  test('fromJson should return valid model', () {
    final result = ProductModel.fromJson(tProductJson);
    expect(result, tProductModel);
  });

  test('toJson should return correct map', () {
    final result = tProductModel.toJson();
    expect(result, tProductJson);
  });
}
