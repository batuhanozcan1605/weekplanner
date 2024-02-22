import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;


  PaywallWidget(
      {required this.title, required this.description, required this.packages,required this.onClickedPackage});

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),),
            SizedBox(height: 16,),
            Text(widget.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontFamily: 'Montserrat')),
            SizedBox(height: 16,),
            buildPackage(context),
          ],
        ),
      ),
    );
  }

  Widget buildPackage(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final package = widget.packages[0];
    final product = package.storeProduct;

    return Card(
      color: colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        title: Text(
            product.title,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(product.description),
        trailing: Text(
          product.priceString,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onTap: () => widget.onClickedPackage(package),
      ),
    );
  }
}
