// search.dart
import 'package:flutter/material.dart';
import 'home.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(20, 120);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // grab your full product list (you can swap this out with your real data source)
    final results = HomePage().myProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),

            // ← Back arrow + title
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(63, 81, 243, 1),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Center(
                  child: Text(
                    'Search Product',
                    style: theme.textTheme.titleMedium!
                        .copyWith(color: Colors.black87),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ← Search field + filter icon
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Leather',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Color.fromRGBO(63, 81, 243, 1),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(63, 81, 243, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {
                      // TODO: scroll/animate to filter panel
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ← Search results list
            ...results.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ────────── Image ──────────
                        AspectRatio(
                          aspectRatio: 18 / 11,
                          child: Image.asset(
                            p.assetName,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Product name
                                  Expanded(
                                    child: Text(
                                      p.name,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // p price
                                  Text(
                                    '\$${p.price.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              // ── Second row: Description + Rating ──
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Product description
                                  Expanded(
                                    child: Text(
                                      p.category,
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
                                        '(${p.rating.toStringAsFixed(1)})',
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
                )),

            const SizedBox(height: 24),

            // ← Filter panel
            Text(
              'Category',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Price',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 200,
              divisions: 100,
              labels: RangeLabels(
                '\$${_priceRange.start.toInt()}',
                '\$${_priceRange.end.toInt()}',
              ),
              activeColor: const Color.fromRGBO(
                  63, 81, 243, 1), // Sets the active range color
              inactiveColor:
                  Colors.grey.shade300, // Sets the inactive range color
              onChanged: (newRange) {
                setState(() => _priceRange = newRange);
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(63, 81, 243, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text('APPLY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
