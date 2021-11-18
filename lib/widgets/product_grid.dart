import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopping_app_again/providers/Products.dart';
import 'package:shopping_app_again/widgets/product_item.dart';

// ignore: must_be_immutable
class ProductGrid extends StatelessWidget {
  bool fav;
  ProductGrid(this.fav);
  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products>(context, ); 
    final products = fav ? productsdata.showfavo: productsdata.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,

      // ignore: missing_return
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        );
      },

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

