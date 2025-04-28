class Product {
  int id;
  String name;
  String description;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  String toString() {
    return '[$id] $name — ${price.toStringAsFixed(2)}ETB   $description';
  }
}
