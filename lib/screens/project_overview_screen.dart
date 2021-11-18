import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/Products.dart';
import 'package:shopping_app_again/providers/cart.dart';
import 'package:shopping_app_again/screens/cartscreen.dart';
import 'package:shopping_app_again/widgets/app_drawer.dart';
import 'package:shopping_app_again/widgets/badge.dart';

import 'package:shopping_app_again/widgets/product_grid.dart';

enum FilterOption { OnlyFavorite, AllItem }

// ignore: must_be_immutable
class ProjectOverviewScreen extends StatefulWidget {
  @override
  _ProjectOverviewScreenState createState() => _ProjectOverviewScreenState();
}

class _ProjectOverviewScreenState extends State<ProjectOverviewScreen> {
  var showfav = false;
  var isinit = true;
  var isloading = false;
  @override
  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isloading = true;
      });

      Provider.of<Products>(context)
          .fetchandsetProducts()
          .then(
            (value) => setState(() {
              isloading = false;
            }),
          )
          .catchError((error) {return
        
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('an error occured'),
            content: Text('something went wrong'),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () =>exit(0),
                  child: Text('okay'))
            ],
          ),
        );
      });
    }
    isinit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption slectedvalue) {
                setState(() {
                  if (slectedvalue == FilterOption.OnlyFavorite) {
                    showfav = true;
                    print('button ok');
                  } else {
                    showfav = false;
                  }
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('only favorite'),
                      value: FilterOption.OnlyFavorite,
                    ),
                    PopupMenuItem(
                      child: Text('all'),
                      value: FilterOption.AllItem,
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemcount.toString()),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          )
        ],
        title: Text('shop'),
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showfav),
      drawer: AppDrawer(),
    );
  }
}
