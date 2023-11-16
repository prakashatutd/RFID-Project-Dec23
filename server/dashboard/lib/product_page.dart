import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

// Basic product info shown on inventory page
class ProductBasicInfo {
  final int id;
  final String name;
  final String category;
  final int resupplyThreshold;
  int quantity;

  ProductBasicInfo(this.id, this.name, this.category, this.resupplyThreshold, this.quantity) {

  }
}

// Additional product info that is shown in sidebar
class ProductDetailedInfo {
  final String imageUrl;
  final String description;
  final int width;
  final int height;
  final int depth;
  final int weight;

  ProductDetailedInfo(this.imageUrl, this.description, this.width, this.height, this.depth, this.weight) {

  }
}

class _ProductPageState extends State<ProductPage> {
  // Mock data for demonstration purposes
  Map<int, ProductBasicInfo> basicProducts = {
    111222333 : ProductBasicInfo(111222333, 'BIC Soft Feel Ballpoint Pen 25ct', 'Pens', 25, 40),
    777555444 : ProductBasicInfo(777555444, 'X-ACTO Quiet Pro 35ct', 'Pencil Sharpeners', 5, 2),
    444999000 : ProductBasicInfo(444999000, 'Crayola Washable Markers 100ct', 'Markers', 15, 30),
  };
  Map<int, ProductDetailedInfo> detailedProducts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Product Page') {
                Navigator.pushNamed(context, '/product');
              } else if (value == 'Scan History') {
                Navigator.pushNamed(context, '/ScanHistory');
              } else if (value == 'Trends') {
                Navigator.pushNamed(context, '/trends');
              } else if (value == 'Orders Page') {
                Navigator.pushNamed(context, '/orders');
              }
            },
            itemBuilder: (BuildContext context) {
              return {
                'Product Page',
                'Scan History',
                'Trends',
                'Orders Page',
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Inventory',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Product ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Resupply Threshold', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: basicProducts.values.map((basicProduct) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                basicProduct.id.toString(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            DataCell(Text(basicProduct.name)),
                            DataCell(Text(basicProduct.category)),
                            DataCell(Text(basicProduct.resupplyThreshold.toString())),
                            DataCell(Text(basicProduct.quantity.toString())),
                          ]);
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Defintely one of the products of all time!',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
