import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

// Basic product info shown on inventory page
class ProductBasicInfo {
  final int id;
  final String name;
  final String category;
  final int resupplyThreshold;
  int quantity;

  ProductBasicInfo(
    this.id,
    this.name,
    this.category,
    this.resupplyThreshold,
    this.quantity) {
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

  ProductDetailedInfo(
    this.imageUrl,
    this.description,
    this.width,
    this.height,
    this.depth,
    this.weight) {
  }
}

class _InventoryPageState extends State<InventoryPage> {
  // Mock data for demonstration purposes
  Map<int, ProductBasicInfo> basicProducts = {
    111222333 : ProductBasicInfo(111222333, 'BIC Soft Feel Ballpoint Pen 25ct', 'Pens', 25, 40),
    777555444 : ProductBasicInfo(777555444, 'X-ACTO Quiet Pro 35ct', 'Pencil Sharpeners', 5, 2),
    444999000 : ProductBasicInfo(444999000, 'Crayola Washable Markers 100ct', 'Markers', 15, 30),
  };
  Map<int, ProductDetailedInfo> detailedProducts = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
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
    );
  }
}
