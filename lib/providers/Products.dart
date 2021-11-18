import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app_again/models/Http_Exception.dart';

import 'package:shopping_app_again/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showfavo {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findbyid(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchandsetProducts() async {
    var url = Uri.https(
        'shopping-app-879c9-default-rtdb.firebaseio.com', '/products.json');
    try {
      var response = await http.get(url);
      var extrateddata = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedproducts = [];
      extrateddata.forEach((prodid, prodata) {
        loadedproducts.add(
          Product(
            id: prodid,
            title: prodata['title'],
            description: prodata['description'],
            price: prodata['price'],
            imageUrl: prodata['imageUrl'],
            isFavorite: prodata['isFavorite'],
          ),
        );
        _items = loadedproducts;
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.https(
        'shopping-app-879c9-default-rtdb.firebaseio.com', '/products.json');
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );

      final newproduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newproduct) async {
    final proindex = _items.indexWhere((element) => element.id == id);
    if (proindex >= 0) {
      var url = Uri.https('shopping-app-879c9-default-rtdb.firebaseio.com',
          '/products/$id.json');
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newproduct.title,
            'description': newproduct.description,
            'price': newproduct.price,
            'imageUrl': newproduct.imageUrl
          },
        ),
      );
      _items[proindex] = newproduct;
      notifyListeners();
    }
  }

  Future<void> deletepro(String id) async {
    var url = Uri.https(
        'shopping-app-879c9-default-rtdb.firebaseio.com', '/products/$id.json ');
    final existingProindecx = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProindecx];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProindecx, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product.');
    }
    existingProduct = null;
  }
}
