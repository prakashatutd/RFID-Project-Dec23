import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class ProductInfo {
  final String id;
  final String name;
  final String imageUrl;
  final String dimensions;
  final String description;

  ProductInfo({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.dimensions,
    required this.description,
  });
}

class _ProductPageState extends State<ProductPage> {
  // Mock data for demonstration purposes
  List<ProductInfo> products = [
    ProductInfo(id: '1', name: 'Product 1', imageUrl: '', dimensions: '', description: 'Description for Product 1'),
    // ... other products
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
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
              'Product Page',
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
                        DataColumn(label: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Min Storage Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Resupply Threshold', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Current Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: products.map((product) {
                        return DataRow(cells: [
                          DataCell(
                            Text(
                              product.id,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          DataCell(Text(product.name)),
                          DataCell(Text(product.imageUrl)),
                          DataCell(Text(product.dimensions)),
                          DataCell(Text(product.description)),
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
                        'Description for Product 1',
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
