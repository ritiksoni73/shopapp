import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/Products.dart';
import 'package:shopping_app_again/providers/cart.dart';
import 'package:shopping_app_again/providers/order.dart';
import 'package:shopping_app_again/screens/Product_details.dart';
import 'package:shopping_app_again/screens/cartscreen.dart';
import 'package:shopping_app_again/screens/editproduct.dart';
import 'package:shopping_app_again/screens/orders_screen.dart';
import 'package:shopping_app_again/screens/project_overview_screen.dart';
import 'package:shopping_app_again/screens/user_product_screen.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: MaterialApp(
        title: 'shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.red,
        ),
        home: ProjectOverviewScreen(),
        routes: {
          ProductDetail.routname: (ctx) => ProductDetail(),
          CartScreen.routename: (ctx) => CartScreen(),
          Orderscreen.routename: (ctx) => Orderscreen(),
          UserProductScreen.routename: (ctx) => UserProductScreen(),
          EditProductScreen.routename: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

// 
