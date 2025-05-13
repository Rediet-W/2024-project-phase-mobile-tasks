import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProduct(ProductModel product);
  Future<ProductModel> getCachedProduct(String id);
}

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> products) {
    final jsonList = products.map((p) => p.toJson()).toList();
    return sharedPreferences.setString(
      CACHED_PRODUCTS,
      json.encode(jsonList),
    );
  }

  @override
  Future<List<ProductModel>> getCachedProducts() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString) as List;
      final models =
          decoded.map((jsonMap) => ProductModel.fromJson(jsonMap)).toList();
      return Future.value(models);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    final products = jsonString != null
        ? (json.decode(jsonString) as List)
            .map((m) => ProductModel.fromJson(m))
            .toList()
        : <ProductModel>[];
    // Check if the product already exists in the list
    final index = products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      products[index] = product;
    } else {
      products.add(product);
    }

    return sharedPreferences.setString(
      CACHED_PRODUCTS,
      json.encode(products.map((p) => p.toJson()).toList()),
    );
  }

  @override
  Future<ProductModel> getCachedProduct(String id) {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List decoded = json.decode(jsonString) as List;
      final products = decoded.map((m) => ProductModel.fromJson(m)).toList();
      try {
        final found = products.firstWhere((p) => p.id == id);
        return Future.value(found);
      } catch (_) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }
}
