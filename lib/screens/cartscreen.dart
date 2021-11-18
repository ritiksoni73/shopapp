import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/cart.dart' show Cart;
import 'package:shopping_app_again/providers/order.dart';
import 'package:shopping_app_again/widgets/cartitem.dart';

class CartScreen extends StatelessWidget {
  static const routename = '/cartscreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(' \$${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // ignore: deprecated_member_use
                  OrderBotton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (BuildContext context, int i) {
                return CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].price,
                  cart.items.keys.toList()[i],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderBotton extends StatefulWidget {
  const OrderBotton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderBottonState createState() => _OrderBottonState();
}

class _OrderBottonState extends State<OrderBotton> {
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || isloading)
          ? null
          : () async {
              setState(() {
                isloading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                isloading = false;
              });
              widget.cart.clear();
            },
      child:isloading?CircularProgressIndicator(): Text('Order now'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
