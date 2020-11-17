import 'package:Dimodo/models/product/product.dart';
import 'package:Dimodo/models/product/productModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'detail/product_detail.dart';

class ItemDeepLink extends StatefulWidget {
  const ItemDeepLink({this.itemId});

  final int itemId;

  @override
  _ItemDeepLinkState createState() => _ItemDeepLinkState();
}

class _ItemDeepLinkState extends State<ItemDeepLink> {
  ProductModel productModel;
  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: productModel.getProductById(widget.itemId),
      builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          case ConnectionState.done:
          default:
            if (snapshot.hasError || snapshot.data.id == null) {
              return Material(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Opps, the product seems no longer exist',
                        style: TextStyle(color: Colors.black),
                      ),
                      FlatButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text(
                          'Go back to home page',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          // return ProductDetail(product: snapshot.data);
        }
      },
    );
  }
}
