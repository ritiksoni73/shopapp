import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/cart.dart';
import 'package:shopping_app_again/providers/product.dart';

import 'package:shopping_app_again/screens/Product_details.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providing = Provider.of<Product>(context, listen: false);
    final cartdata = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetail.routname, arguments: providing.id);
            },
            child: Image.network(
              providing.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            title: Text(providing.title),
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
                builder: (context, product, child) => IconButton(
                      onPressed: () {
                        providing.toggleFavoriteStatus();
                      },
                      color: Theme.of(context).accentColor,
                      icon: Icon(
                        providing.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                    )),
            trailing: IconButton(
              onPressed: () {
                cartdata.addItem(
                  providing.id,
                  providing.price,
                  providing.title,
                );
                // ignore: deprecated_member_use
                 Scaffold.of(context).hideCurrentSnackBar();
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('item added'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'undo',
                      onPressed: () {
                        cartdata.removeSingleItem(providing.id);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
            ),
          )),
    );
  }
}
