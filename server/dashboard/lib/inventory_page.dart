import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import 'api.dart';
import 'common.dart';
import 'data_definitions.dart';

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
  ListQueryParameters _queryParameters = ListQueryParameters();
  InventoryControlSystemAPI _api;

  InventoryDataSource(this._api);

  void filterByCategory(String category) {
    _queryParameters.category = category;
    refreshDatasource();
  }

  void sortBy(String field, bool ascending) {
    if (!ascending)
      _queryParameters.ordering = '-' + field;
    else
      _queryParameters.ordering = field;
    refreshDatasource();
  }

  void searchByName(String name) {
    _queryParameters.search = name;
    refreshDatasource();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    _queryParameters.offset = startIndex;
    _queryParameters.limit = count;
    ListResponse<Product> products = await _api.getProducts(_queryParameters);
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
  int _rowsPerPage = 10;
  InventoryDataSource _dataSource;
  int _sortColumnIndex = 2; // category by default
  bool _sortAscending = true;

  _InventoryPageState(this._dataSource);

  void sortBy(int columnIndex, bool ascending) {
    String sortField = '';
    if (columnIndex == 1)
      sortField = 'name';
    else if (columnIndex == 2)
      sortField = 'category';
    else if (columnIndex == 3)
      sortField = 'rop';
    else
      return;

    _dataSource.sortBy(sortField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),      
      child: AsyncPaginatedDataTable2(
        availableRowsPerPage: const <int>[10, 15, 20, 25],
        errorBuilder: (e) => ErrorAndRetryBox(
          e.toString(),
          () => _dataSource.refreshDatasource()
        ),
        header: Row(
          children: <Widget>[
            Text(
              'Products',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SizedBox(
                width: 400,
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  elevation: const MaterialStatePropertyAll<double?>(3.0),
                ),
              ),
            ),
          ],
        ),
        headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
        initialFirstRowIndex: 0,
        onRowsPerPageChanged: (int? value) {
          _rowsPerPage = value!;
        },
        pageSyncApproach: PageSyncApproach.doNothing,
        rowsPerPage: _rowsPerPage,        
        showFirstLastButtons: true,
        sortArrowIcon: Icons.arrow_drop_up,
        sortAscending: _sortAscending,
        sortColumnIndex: _sortColumnIndex,
        source: _dataSource,
        columns: <DataColumn2>[
          DataColumn2(
            label: Text('Product ID'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Name'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) => sortBy(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Category'),
            size: ColumnSize.M,
            onSort: (columnIndex, ascending) => sortBy(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Resupply Threshold'),
            size: ColumnSize.S,
            numeric: true,
            onSort: (columnIndex, ascending) => sortBy(columnIndex, ascending),
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