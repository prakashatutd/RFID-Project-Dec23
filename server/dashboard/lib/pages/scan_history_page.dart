import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../api.dart';
import '../common/error_retry_box.dart';
import '../data_sources/scan_history_data_source.dart';
import '../models/scan_event.dart';

class ScanHistoryPage extends StatefulWidget {
  final InventoryControlSystemAPI _api;

  const ScanHistoryPage(this._api, {super.key});

  @override
  _ScanHistoryPageState createState() => _ScanHistoryPageState(ScanHistoryDataSource(_api));
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  int _rowsPerPage = 10;
  ScanHistoryDataSource _dataSource;
  int _sortColumnIndex = 0; // Default sort column is 'Scan time'
  bool _sortAscending = true;

  _ScanHistoryPageState(this._dataSource);

  void sortBy(int columnIndex, bool ascending) {
    if (columnIndex == 3) {
      // Sort by 'action' column
      _dataSource.sortBy('action', ascending);
    } else {
      // Handle sorting for other columns if needed
      String field = ''; // Determine the field based on columnIndex
      _dataSource.sortBy(field, ascending);
    }

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
            size: ColumnSize.M
          ),
          DataColumn2(
            label: Text('Product Name'),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text('Action'),
            size: ColumnSize.M,           
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