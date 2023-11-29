import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import 'api.dart';

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

class InventoryDataSource extends AsyncDataTableSource {
  String? categoryFilter = null;
  String? orderingField = null;
  String? searchField = null;
  InventoryControlSystemAPI _api;

  InventoryDataSource(this._api);

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    ListResponse<Product> products = await _api.getProducts(count, startIndex, categoryFilter, orderingField, searchField);
    return AsyncRowsResponse(
      products.totalCount,
      List<DataRow>.from(products.results.map((Product product) => 
        DataRow(
          cells: <DataCell>[
            DataCell(Text(product.id.toString())),
            DataCell(Text(product.name)),
            DataCell(Text(product.category)),
            DataCell(Text(product.reorderPoint.toString())),
            DataCell(Text(product.quantity.toString())),
          ],
        )
      )),
    );
  } 
}

class InventoryPage extends StatefulWidget {
  final InventoryControlSystemAPI _api;

  const InventoryPage(this._api, {super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState(InventoryDataSource(_api));
}

class _InventoryPageState extends State<InventoryPage> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  InventoryDataSource _inventoryDataSource;

  _InventoryPageState(this._inventoryDataSource);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),      
      child: AsyncPaginatedDataTable2(
        availableRowsPerPage: <int>[10, 20, 30],
        errorBuilder: (e) => _ErrorAndRetryBox(
          e.toString(),
          () => _inventoryDataSource.refreshDatasource()
        ),
        headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
        initialFirstRowIndex: 0,
        onRowsPerPageChanged: (int? value) {
          _rowsPerPage = value!;
        },
        pageSyncApproach: PageSyncApproach.doNothing,
        rowsPerPage: _rowsPerPage,        
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

class _ErrorAndRetryBox extends StatelessWidget {
  const _ErrorAndRetryBox(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120,
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Oops! $errorMessage', style: const TextStyle(color: Colors.white)),
            TextButton(
              onPressed: retry,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  Text('Retry', style: TextStyle(color: Colors.white))
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}