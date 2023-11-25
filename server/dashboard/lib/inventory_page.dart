import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

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

// Additional product info that is shown in pop-up
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

class InventoryDataSource extends DataTableSource {
  final List<ProductBasicInfo> _products = <ProductBasicInfo>[
    ProductBasicInfo(111222333, 'BIC Soft Feel Ballpoint Pen 25ct', 'Pens', 25, 40),
    ProductBasicInfo(777555444, 'X-ACTO Quiet Pro 35ct', 'Pencil Sharpeners', 5, 2),
    ProductBasicInfo(444999000, 'Crayola Washable Markers 100ct', 'Markers', 15, 30),
    ProductBasicInfo(444111555, 'Fresh Oranges 60ct', 'Produce', 20, 57),
  ];

  @override
  int get rowCount => _products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index > rowCount)
      return null;

    final ProductBasicInfo product = _products[index];

    return DataRow(
      cells: <DataCell>[
        DataCell(Text(product.id.toString())),
        DataCell(Text(product.name)),
        DataCell(Text(product.category)),
        DataCell(Text(product.resupplyThreshold.toString())),
        DataCell(Text(product.quantity.toString())),
      ],
    );
  }
}

final InventoryDataSource _inventoryDataSource = InventoryDataSource();

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),      
      child: PaginatedDataTable2(
        availableRowsPerPage: <int>[10, 20, 30],
        headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
        rowsPerPage: _rowsPerPage,
        onRowsPerPageChanged: (int? value) {
          _rowsPerPage = value!;
        },
        showFirstLastButtons: true,
        source: _inventoryDataSource,
        columns: const <DataColumn2>[
          DataColumn2(
            label: Text('Product ID'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Name'),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text('Category'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Resupply Threshold'),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text('Quantity'),
            size: ColumnSize.S,
            numeric: true,
          ),
        ],
      ),
    );
  }
}
