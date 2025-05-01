import 'package:flutter/material.dart';
import 'package:rediet_woudma/addproduct.dart';
import 'package:rediet_woudma/detail.dart';
import 'package:rediet_woudma/editproduct.dart';
import 'package:rediet_woudma/home.dart';
import 'package:rediet_woudma/search.dart';

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
