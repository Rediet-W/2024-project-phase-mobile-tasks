import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'detail.dart';
import 'editproduct.dart';
import 'home.dart';
import 'search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task 6',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/add': (context) => const AddProduct(),
        '/edit': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return EditProduct(product: product);
        },
        '/search': (context) => const SearchPage(),
        '/detail': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return DetailPage(product: product);
        },
        // '/second': (context) => const SecondScreen(),
      },
    );
  }
}
