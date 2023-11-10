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
    ProductInfo(id: '1', name: 'Product 1', imageUrl: '', dimensions: '', description: ''),
    // ... other products
  ];

  // Function to edit table data
  void _editTableData() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Table Data'),
          content: Column(
            children: products.map((product) {
              // Create text editing controllers for each field
              TextEditingController idController = TextEditingController(text: product.id);
              TextEditingController nameController = TextEditingController(text: product.name);
              TextEditingController imageUrlController = TextEditingController(text: product.imageUrl);
              TextEditingController dimensionsController = TextEditingController(text: product.dimensions);
              TextEditingController descriptionController = TextEditingController(text: product.description);

              return Column(
                children: [
                  // Text field for Product ID
                  TextField(controller: idController, decoration: InputDecoration(labelText: 'Product ID')),
                  // Text field for Product Name
                  TextField(controller: nameController, decoration: InputDecoration(labelText: 'Product Name')),
                  // Text field for Image URL
                  TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'Image URL')),
                  // Text field for Dimensions
                  TextField(controller: dimensionsController, decoration: InputDecoration(labelText: 'Dimensions')),
                  // Text field for Description
                  TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Handle save/edit logic here
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

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
            ElevatedButton(
              onPressed: _editTableData,
              child: Text('Edit Table Data'),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
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
                    DataCell(Text(product.id)),
                    DataCell(Text(product.name)),
                    DataCell(Text(product.imageUrl)),
                    DataCell(Text(product.dimensions)),
                    DataCell(Text(product.description)),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
