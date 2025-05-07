import 'package:flutter/material.dart';
import 'home.dart';

class EditProduct extends StatefulWidget {
  final Product product;
  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController _nameCtrl;
  late TextEditingController _categoryCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descriptionCtrl;

  @override
  void initState() {
    super.initState();
    // pre-fill with existing values
    _nameCtrl = TextEditingController(text: widget.product.name);
    _categoryCtrl = TextEditingController(text: widget.product.category);
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
    _descriptionCtrl = TextEditingController(text: widget.product.description);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _priceCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    // Here, read your controllers and update your product or send to backend:
    final updated = widget.product.copyWith(
      name: _nameCtrl.text,
      category: _categoryCtrl.text,
      price: double.tryParse(_priceCtrl.text) ?? widget.product.price,
      description: _descriptionCtrl.text,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(63, 81, 243, 1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Product',
          style: theme.textTheme.titleMedium!.copyWith(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // image placeholder – you can swap this with an actual Image widget
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo_size_select_actual_rounded,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload image',
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Name ──
            Text('Name', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Category ──
            Text('Category', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _categoryCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Price ──
            Text('Price', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _priceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixText: '\$',
              ),
            ),

            const SizedBox(height: 16),

            // ── Description ──
            Text('Description', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Buttons ──
            Row(
              children: [
                // Cancel
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('CANCEL'),
                    ),
                  ),
                ),

                const SizedBox(width: 40),

                // Save
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(63, 81, 243, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
