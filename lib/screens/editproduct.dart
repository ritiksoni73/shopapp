import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_again/providers/Products.dart';
import 'package:shopping_app_again/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routename = '/editproductscreen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocus = FocusNode();
  final _discriptionfocus = FocusNode();
  final _imageurlfocus = FocusNode();
  final _imageinputcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var isinit = false;
  var _initvalue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var isloading = false;

  @override
  void initState() {
    _imageurlfocus.addListener(updateImageurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isinit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findbyid(productId);
        _initvalue = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': ' ',
        };
        _imageinputcontroller.text = _editProduct.imageUrl;
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  void updateImageurl() {
    if (!_imageurlfocus.hasFocus) {
      if (_imageinputcontroller.text.isEmpty ||
          !_imageinputcontroller.text.startsWith('http') &&
              !_imageinputcontroller.text.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveform() async {
    setState(() {
      isloading = true;
    });
    final isvalid = _formkey.currentState.validate();
    if (!isvalid) {
      return;
    }
    _formkey.currentState.save();
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('an error occured'),
            content: Text('something went wrong'),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('okay'))
            ],
          ),
        );
      }
    }
    setState(() {
      isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _discriptionfocus.dispose();
    _pricefocus.dispose();
    _imageinputcontroller.dispose();
    // _imageurlfocus.dispose();
    _imageurlfocus.removeListener(updateImageurl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(
            onPressed: () {
              saveform();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'title'),
                      initialValue: _initvalue['title'],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: value,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'price'),
                      initialValue: _initvalue['price'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please provide a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter a number greater than zero';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _pricefocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_discriptionfocus);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: double.parse(value),
                          imageUrl: _editProduct.imageUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Discription'),
                      initialValue: _initvalue['description'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a Discription';
                        }
                        if (value.length < 10) {
                          return 'should be atleast 10 character long';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _discriptionfocus,
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: value,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageinputcontroller.text.isEmpty
                              ? Text(
                                  'enter Image url',
                                  textAlign: TextAlign.center,
                                )
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.network(_imageinputcontroller.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide a url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'please enter a valid url';
                                }

                                return null;
                              },
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageurlfocus,
                              controller: _imageinputcontroller,
                              onSaved: (value) {
                                _editProduct = Product(
                                  id: _editProduct.id,
                                  title: _editProduct.title,
                                  description: _editProduct.description,
                                  price: _editProduct.price,
                                  imageUrl: value,
                                  isFavorite: _editProduct.isFavorite,
                                );
                              },
                              onFieldSubmitted: (_) {
                                saveform();
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
