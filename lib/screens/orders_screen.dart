import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/order.dart';
import 'package:shopping_app_again/widgets/app_drawer.dart';
import 'package:shopping_app_again/widgets/orderitem.dart';

class Orderscreen extends StatefulWidget {
  static const routename = '/orderscreen';

  @override
  _OrderscreenState createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  Future _orderfuture;
  Future _obtainOrderFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndSetorder();
  }

  @override
  void initState() {
    _orderfuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _orderfuture,
          builder: (context, datsnapshot) {
            if (datsnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderdata, _) => ListView.builder(
                  itemCount: orderdata.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Orderitems(orderdata.orders[index]);
                  },
                ),
              );
            }
          },
        ));
  }
}
