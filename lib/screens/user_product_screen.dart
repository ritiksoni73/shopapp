import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/Products.dart';
import 'package:shopping_app_again/screens/editproduct.dart';
import 'package:shopping_app_again/widgets/app_drawer.dart';
import 'package:shopping_app_again/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = '/userproductscreen';


  Future<void> onrefresh(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchandsetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routename);
            },
            icon: Icon(Icons.add),
          ),
        ], 
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>onrefresh(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productdata.items.length,
            itemBuilder: (BuildContext context, int index) {
              return UserproductItem(
                  productdata.items[index].id,
                  productdata.items[index].title,
                  productdata.items[index].imageUrl);
            },
          ),
        ),
      ),
    );
  }
}
