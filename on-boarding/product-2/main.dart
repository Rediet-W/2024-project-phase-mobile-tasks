import 'dart:io';
import 'product_manager.dart';

void main() {
  final manager = ProductManager();

  while (true) {
    print('''
=== eCommerce CLI ===
Hello! What would you like to do?
This is a simple product management system.
1. Add Product
2. View All Products
3. View Single Product
4. Edit Product
5. Delete Product
0. Exit
Choose an option:''');

    final input = stdin.readLineSync();
    switch (input) {
      case '1':
        stdout.write('Name: ');
        final name = stdin.readLineSync()!;
        stdout.write('Description: ');
        final desc = stdin.readLineSync()!;
        stdout.write('Price: ');
        final price = double.tryParse(stdin.readLineSync()!) ?? 0.0;
        manager.addProduct(name, desc, price);
        break;

      case '2':
        manager.viewAll();
        break;

      case '3':
        stdout.write('Product ID: ');
        final id = int.tryParse(stdin.readLineSync()!) ?? -1;
        manager.viewProduct(id);
        break;

      case '4':
        stdout.write('Product ID to edit: ');
        final idEdit = int.tryParse(stdin.readLineSync()!) ?? -1;
        stdout.write('New Name (leave blank to keep): ');
        final newName = stdin.readLineSync();
        stdout.write('New Description (blank to keep): ');
        final newDesc = stdin.readLineSync();
        stdout.write('New Price (blank to keep): ');
        final priceInput = stdin.readLineSync();
        final newPrice =
            priceInput!.isEmpty ? null : double.tryParse(priceInput);
        manager.editProduct(
          idEdit,
          name: newName!.isEmpty ? null : newName,
          description: newDesc!.isEmpty ? null : newDesc,
          price: newPrice,
        );
        break;

      case '5':
        stdout.write('Product ID to delete: ');
        final idDel = int.tryParse(stdin.readLineSync()!) ?? -1;
        manager.deleteProduct(idDel);
        break;

      case '0':
        print('Bye!');
        return;

      default:
        print('Invalid option\n');
    }
  }
}
