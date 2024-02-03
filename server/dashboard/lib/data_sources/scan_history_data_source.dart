import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../api.dart';
import '../models/scan_event.dart';

class ScanHistoryDataSource extends AsyncDataTableSource {
  ListQueryParameters _queryParameters = ListQueryParameters();
  InventoryControlSystemAPI _api;
  bool _sortActionAscending = true;

  ScanHistoryDataSource(this._api);

  void filterByCategory(String category) {
    _queryParameters.category = category;
    refreshDatasource();
  }

  void sortBy(String field, bool ascending) {
    if (field == 'action') {
      _sortActionAscending = ascending;
    } else {
      if (!ascending) {
        _queryParameters.ordering = '-' + field;
      } else {
        _queryParameters.ordering = field;
      }
    }
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

    ListResponse<ScanEvent> scanEvents = await _api.getScanEvents(_queryParameters);

    if (_sortActionAscending) {
      scanEvents.results.sort((a, b) => a.action.compareTo(b.action));
    } else {
      scanEvents.results.sort((a, b) => b.action.compareTo(a.action));
    }

    return AsyncRowsResponse(
      scanEvents.totalCount,
      List<DataRow>.from(scanEvents.results.map((ScanEvent scanEvent) =>
          DataRow(
            cells: <DataCell>[
              DataCell(Text(scanEvent.scanTime.toString())),
              DataCell(Text(scanEvent.gateId)),
              DataCell(Text(scanEvent.productName)),
              DataCell(Text(scanEvent.action.toString())),
              DataCell(Text(scanEvent.quantity.toString())),
            ],
          ),
      )),
    );
  }
}