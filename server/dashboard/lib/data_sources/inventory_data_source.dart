import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../api.dart';
import '../models/product.dart';

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

    List<DataRow> dataRows = products.results.map((Product product) {
      // Highlight products that need to be reordered red
      bool highlightRed = product.quantity < product.reorderPoint;

      return DataRow(
        color: highlightRed ? MaterialStateProperty.all<Color>(Colors.red[100]!) : null,
        cells: <DataCell>[
          DataCell(Text(product.id.toString())),
          DataCell(Text(product.name)),
          DataCell(Text(product.category)),
          DataCell(Text(product.reorderPoint.toString())),
          DataCell(Text(product.quantity.toString())),
        ],
      );
    }).toList();

    return AsyncRowsResponse(
      products.totalCount,
      List<DataRow>.from(dataRows),
    );
  }
}