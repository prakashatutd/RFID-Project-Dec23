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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'product') {
                // Handle Product Page option
              } else if (value == 'history') {
                // Handle Scan History option
              } else if (value == 'trends') {
                // Handle Trends option
              } else if (value == 'orders') {
                // Handle Orders Page option
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
                  rows: [
                    DataRow(cells: [
                      DataCell(
                        Tooltip(
                          message: 'Product 1 Details',
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button click
                            },
                            child: Text('1'),
                          ),
                        ),
                      ),
                      DataCell(Text('Product 1')),
                      DataCell(Text('10')),
                      DataCell(Text('5')),
                      DataCell(Text('15')),
                    ]),
                    // ... other rows
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}