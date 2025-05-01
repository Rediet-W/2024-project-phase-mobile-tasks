import 'package:flutter/material.dart';

class Product {
  final String assetName;
  final String name;
  final String description;
  final double rating;
  final double price;
  final String category;

  Product({
    required this.assetName,
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    required this.category,
  });
  Product copyWith({
    String? assetName,
    String? category,
    String? name,
    String? description,
    double? rating,
    double? price,
  }) {
    return Product(
      assetName: assetName ?? this.assetName,
      category: category ?? this.category,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      price: price ?? this.price,
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Product> myProducts = [
    Product(
        assetName: 'assets/images/coach.png',
        name: 'COACH',
        description:
            "Women's High Line Update Signature Canvas Sneakers, featuring a modern design with premium materials for ultimate comfort and style. Perfect for casual outings or pairing with your favorite outfits.",
        rating: 4.0,
        price: 120,
        category: 'women'),
    Product(
        assetName: 'assets/images/clarks.png',
        name: 'Clarks',
        description:
            "Women's Cloud Steppers Breeze Vibe Flat Shoes, designed with innovative comfort technology to provide all-day support and style. These lightweight flats feature a breathable upper, cushioned insole, and flexible outsole, making them perfect for long walks, casual outings, or even a day at the office. The sleek design ensures they pair effortlessly with a variety of outfits, from jeans to dresses, while the durable construction guarantees lasting wear. Experience the perfect blend of fashion and functionality with these versatile shoes.",
        rating: 4.5,
        price: 99,
        category: 'women'),
    Product(
        assetName: 'assets/images/cole.png',
        name: 'Cole Haan',
        description:
            "Men's Grand Remix Lace-Up Knit Oxford Shoes, a perfect blend of modern style and timeless elegance. These shoes are crafted with a breathable knit upper that ensures all-day comfort, while the lace-up design provides a secure fit. The lightweight construction and cushioned insole make them ideal for extended wear, whether you're heading to the office, attending a formal event, or enjoying a casual outing. The durable outsole offers excellent traction and stability, ensuring you can walk with confidence on various surfaces. With their versatile design, these oxfords pair effortlessly with both casual and formal attire, making them a must-have addition to any wardrobe. Experience the perfect combination of fashion, functionality, and comfort with these premium shoes.",
        rating: 4.6,
        price: 100,
        category: 'men'),
    Product(
        assetName: 'assets/images/baby.png',
        name: 'First Impressions',
        description:
            "Baby Boys or Baby Girls Slip On Soft Sole Sneakers, Created for Macy's. These adorable sneakers are designed with your little one's comfort and style in mind. Featuring a soft sole that provides gentle support for tiny feet, these slip-on shoes are perfect for babies who are just starting to explore the world. The breathable fabric ensures all-day comfort, while the elasticized opening makes them easy to put on and take off. The versatile design pairs well with a variety of outfits, making them a practical and stylish choice for any occasion. Whether it's a family outing, a playdate, or a casual day at home, these sneakers are a must-have for your baby's wardrobe. Durable and easy to clean, they are built to withstand the adventures of early childhood while keeping your little one looking cute and feeling cozy.",
        rating: 4.9,
        price: 16.99,
        category: 'children'),
  ];

  List<GestureDetector> _buildGridCards(BuildContext context) {
    final theme = Theme.of(context);

    return myProducts.map((product) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: product,
          );
        },
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ────────── Image ──────────
              AspectRatio(
                aspectRatio: 18 / 11,
                child: Image.asset(
                  product.assetName,
                  fit: BoxFit.cover,
                ),
              ),

              // ────────── Text block ──────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── First row: Name + Price ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product name
                        Expanded(
                          child: Text(
                            product.name,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Product price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // ── Second row: Description + Rating ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product description
                        Expanded(
                          child: Text(
                            product.category,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Rating star + value
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '(${product.rating.toStringAsFixed(1)})',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('July 14, 2023', style: TextStyle(fontSize: 8)),
            Row(
              children: [
                Text('Hello,'),
                Text(
                  'Yohannes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded)),
              ))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Products',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/search',
                        );
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey[300],
                      )),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: myProducts.length,
                itemBuilder: (context, index) {
                  return _buildGridCards(context)[index];
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(63, 81, 243, 1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
