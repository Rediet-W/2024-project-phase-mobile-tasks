import 'package:flutter/material.dart';
import 'home.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final List<int> sizes = [for (var i = 32; i <= 45; i++) i];
  int selectedSize = 36;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            child: Stack(
              children: [
                Image.asset(
                  p.assetName,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.contain,
                ),
                Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                            color: Color.fromRGBO(63, 81, 243, 1),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      )),
                ),
              ],
            ),
          ),

          // ─── Details ───
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p.category,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              p.rating.toStringAsFixed(1),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p.name,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${p.price.toStringAsFixed(0)}',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Size:',
                      style: theme.textTheme.titleLarge,
                    ),

                    const SizedBox(height: 8),

                    // ─── Scrollable size selector ───
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sizes.length,
                        itemBuilder: (_, i) {
                          final s = sizes[i];
                          final isSelected = s == selectedSize;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSize = s;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 12, bottom: 4),
                              width: 50,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color.fromRGBO(63, 81, 243, 1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                s.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      p.description,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 24),

                    // ─── Buttons ───
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text(
                                'DELETE',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(63, 81, 243, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit',
                                    arguments: p);
                              },
                              child: const Text('UPDATE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
