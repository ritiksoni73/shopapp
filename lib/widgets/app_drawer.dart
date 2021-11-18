import 'package:flutter/material.dart';
import 'package:shopping_app_again/screens/orders_screen.dart';
import 'package:shopping_app_again/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.shop,
              ),
              title: Text('shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.payment,
              ),
              title: Text('orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(Orderscreen.routename);
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.payment,
              ),
              title: Text('your product'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routename);
              }),
        ],
      ),
    );
  }
}
