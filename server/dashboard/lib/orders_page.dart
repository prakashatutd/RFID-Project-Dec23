import 'package:flutter/material.dart';

class Order {
  final String productId;
  final String productName;
  final int quantity;
  final DateTime dateCreated;
  final DateTime dateCompleted;

  Order({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.dateCreated,
    required this.dateCompleted,
  });
}

class OrdersPage extends StatelessWidget {
  final List<Order> orders = [
    Order(
      productId: '1',
      productName: 'Product 1',
      quantity: 5,
      dateCreated: DateTime(2023, 10, 1),
      dateCompleted: DateTime(2023, 10, 5),
    ),
    // Add more sample orders here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle new order creation logic here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjust button size here
              ),
              child: Text('Create New Order', style: TextStyle(fontSize: 18)), // Adjust text size here
            ),
          ),
          Expanded(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Product ID')),
                DataColumn(label: Text('Product Name')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Date Created')),
                DataColumn(label: Text('Date Completed')),
              ],
              rows: orders
                  .map(
                    (order) => DataRow(cells: [
                      DataCell(Text(order.productId)),
                      DataCell(Text(order.productName)),
                      DataCell(Text(order.quantity.toString())),
                      DataCell(Text(order.dateCreated.toString())),
                      DataCell(Text(order.dateCompleted.toString())),
                    ]),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
