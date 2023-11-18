import 'package:flutter/material.dart';

class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  _ScanHistoryPageState createState() => _ScanHistoryPageState();
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

class _ScanHistoryPageState extends State<ScanHistoryPage> {
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
                  DataColumn(label: Text('Gate ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Product ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('1')),
                    DataCell(Text('234080941')),
                    DataCell(Text('Pencil Case')),
                    DataCell(Text('Incoming')),
                    DataCell(Text('ISO TIMESTAMP')),
                  ]),
                  // ... other rows
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
