import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import 'api.dart';
import 'common.dart';
import 'data_definitions.dart';

class ScanHistoryDataSource extends AsyncDataTableSource {
  ListQueryParameters _queryParameters = ListQueryParameters();
  InventoryControlSystemAPI _api;

  ScanHistoryDataSource(this._api);

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
    ListResponse<ScanEvent> scanEvents = await _api.getScanEvents(_queryParameters);
    return AsyncRowsResponse(
      scanEvents.totalCount,
      List<DataRow>.from(scanEvents.results.map((ScanEvent scanEvent) => 
        DataRow(
          cells: <DataCell>[
            DataCell(Text(scanEvent.scanTime.toString())),
            DataCell(Text(scanEvent.gateId)),
            DataCell(Text(scanEvent.productName)),
            DataCell(Text(scanEvent.action.toString())),
            DataCell(Text(scanEvent.quantity.toString())), // int to String conversion fails for some reason
          ],
        )
      )),
    );
  } 
}

class ScanHistoryPage extends StatefulWidget {
  final InventoryControlSystemAPI _api;

  const ScanHistoryPage(this._api, {super.key});

  @override
  _ScanHistoryPageState createState() => _ScanHistoryPageState(ScanHistoryDataSource(_api));
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  int _rowsPerPage = 10;
  ScanHistoryDataSource _dataSource;
  int _sortColumnIndex = 0; // scan time
  bool _sortAscending = true;

  _ScanHistoryPageState(this._dataSource);

  void sortBy(int columnIndex, bool ascending) {
    if (columnIndex != 0)
      return;

    _dataSource.sortBy('time', ascending);
    setState(() {
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
              'Scan Events',
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
            label: Text('Scan Time'),
            size: ColumnSize.M,
            onSort: (columnIndex, ascending) => sortBy(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Gate ID'),
            size: ColumnSize.M,
            //onSort: (columnIndex, ascending) => sortBy(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Product Name'),
            //onSort: (columnIndex, ascending) => sortBy(columnIndex, ascending),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text('Action'),
            size: ColumnSize.M,
            //onSort: (columnIndex, ascending) => sortBy(columnIndex, ascending),
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