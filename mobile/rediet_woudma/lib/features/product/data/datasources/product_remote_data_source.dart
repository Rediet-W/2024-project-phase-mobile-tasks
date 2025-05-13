import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchAllProducts();

  Future<ProductModel> fetchProductById(String id);

  Future<void> createProduct(ProductModel product,
      {required http.MultipartFile? image});

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);
}

const _BASE_URL =
    'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    final response = await client.get(
      Uri.parse(_BASE_URL),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final List data = decoded['data'];
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> fetchProductById(String id) async {
    final response = await client.get(
      Uri.parse('$_BASE_URL/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      return ProductModel.fromJson(decoded['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> createProduct(ProductModel product,
      {required http.MultipartFile? image}) async {
    final uri = Uri.parse(_BASE_URL);
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = product.name
      ..fields['description'] = product.description
      ..fields['price'] = product.price.toString();
    if (image != null) {
      request.files.add(image);
    }
    final streamed = await client.send(request);
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode != 201 && resp.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final uri = Uri.parse('$_BASE_URL/${product.id}');
    final response = await client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
      }),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$_BASE_URL/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
