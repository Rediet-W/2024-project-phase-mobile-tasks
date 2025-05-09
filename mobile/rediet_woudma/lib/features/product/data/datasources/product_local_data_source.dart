import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();

  Future<void> cacheProducts(List<ProductModel> products);

  Future<ProductModel> getCachedProduct(String id);

  Future<void> cacheProduct(ProductModel product);

  Future<void> removeCachedProduct(String id);
}
