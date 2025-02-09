import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseExample extends StatefulWidget {
  const InAppPurchaseExample({super.key});

  @override
  _InAppPurchaseExampleState createState() => _InAppPurchaseExampleState();
}

class _InAppPurchaseExampleState extends State<InAppPurchaseExample> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = true;
  List<ProductDetails> _products = [];
  final bool _isPurchasePending = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      setState(() {
        _available = false;
      });
      return;
    }

    const Set<String> kIds = <String>{'orange_chat_product_test_01'}; // Google PlayまたはApp Storeで登録したプロダクトID
    final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);
    if (response.error != null) {
      // エラーハンドリング
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam); // 非消耗型アイテムの購入
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In-App Purchase Example'),
      ),
      body: _available
          ? ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text(product.description),
            trailing: ElevatedButton(
              onPressed: () => _buyProduct(product),
              child: Text('購入する'),
            ),
          );
        },
      )
          : Center(child: Text('購入機能が利用できません')),
    );
  }
}
