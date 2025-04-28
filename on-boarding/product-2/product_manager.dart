import 'product.dart';

class ProductManager {
  final List<Product> products = [];
  int _nextId = 1;

  void addProduct(String name, String description, double price) {
    final product = Product(
      id: _nextId++,
      name: name,
      description: description,
      price: price,
    );
    products.add(product);
    print('✅ Added: $product\n');
  }

  void viewAll() {
    if (products.isEmpty) {
      print('No products available.\n');
      return;
    }
    print('All Products:');
    for (var p in products) {
      print(p);
    }
    print('');
  }

  void viewProduct(int id) {
    final p = products.firstWhere(
      (p) => p.id == id,
      orElse: () {
        print('🚫 No product with id $id.\n');
        return null as Product;
      },
    );
    if (p != null) print('🔍 Found:\n$p\n');
  }

  void editProduct(int id, {String? name, String? description, double? price}) {
    final idx = products.indexWhere((p) => p.id == id);
    if (idx == -1) {
      print('🚫 No product with id $id.\n');
      return;
    }
    final old = products[idx];
    products[idx] = Product(
      id: old.id,
      name: name ?? old.name,
      description: description ?? old.description,
      price: price ?? old.price,
    );
    print('Updated: ${products[idx]}\n');
  }

  void deleteProduct(int id) {
    final initialLength = products.length;
    products.removeWhere((p) => p.id == id);
    final removed = products.length < initialLength;
    print(removed
        ? 'Deleted product with id $id.\n'
        : 'No product with id $id to delete.\n');
  }
}
