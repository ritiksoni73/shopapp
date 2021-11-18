import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopping_app_again/providers/order.dart';
import 'package:intl/intl.dart';

class Orderitems extends StatefulWidget {
  final OrderItem order;
  Orderitems(this.order);

  @override
  _OrderitemsState createState() => _OrderitemsState();
}

var isexpanded = false;

class _OrderitemsState extends State<Orderitems> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.datetime),
            ),
            trailing: IconButton(
              icon: Icon(isexpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isexpanded = !isexpanded;
                  print('done');
                });
              },
            ),
          ),
          if (isexpanded)
            Container(
              height: min(widget.order.products.length * 25.0, 1000),
              child: ListView(
                children: widget.order.products
                    .map((e) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${e.quantity}*\$${e.price}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
