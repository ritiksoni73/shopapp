import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/Products.dart';

class ProductDetail extends StatelessWidget {
  static const routname = '/productdetails';
  // String title;
  // ProductDetail(this.title);
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final loadedproduct = Provider.of<Products>(context).findbyid(productid);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  loadedproduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedproduct.price}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10), 
            Text(
              loadedproduct.description,
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
