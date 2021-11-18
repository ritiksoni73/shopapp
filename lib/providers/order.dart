import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shopping_app_again/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem(
    this.id,
    this.amount,
    this.products,
    this.datetime,
  );
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetorder() async {
    var url = Uri.https(
        'shopping-app-879c9-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadedorder = [];
    final extracteddata = json.decode(response.body) as Map<String, dynamic>;
    if (extracteddata == null) {
      return;
    }
    extracteddata.forEach((Orderid, orderdata) {
      loadedorder.add(
        OrderItem(
          Orderid,
          orderdata['amount'],
          (orderdata['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price']))
              .toList(),
          DateTime.parse(
            orderdata['datetime'],
          ),
        ),
      );
    });
    _orders = loadedorder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url = Uri.https(
        'shopping-app-879c9-default-rtdb.firebaseio.com', '/orders.json');
    final timestamp = DateTime.now();
    final response = await http.patch(url,
        body: json.encode({
          'totol': total,
          'datetime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        jsonDecode(response.body)['name'],
        total,
        cartProducts,
        DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
