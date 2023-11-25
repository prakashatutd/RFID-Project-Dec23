import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

enum ScanAction {
  Incoming,
  Outgoing,
}

class ScanEvent {
  final String gateId;
  final int productId;
  final String productName;
  final ScanAction action;
  final int quantity;
  final DateTime scanTime;

  ScanEvent(
    this.gateId,
    this.productId,
    this.productName,
    this.action,
    this.quantity,
    this.scanTime,
  );
}

class ScanHistoryDataSource extends DataTableSource {
  final List<ScanEvent> _scanEvents = <ScanEvent>[
    ScanEvent("ZXY190008", 111222333, 'BIC Soft Feel Ballpoint Pen 25ct', ScanAction.Incoming, 10, DateTime.now()),
    ScanEvent("GRU000007", 777555444, 'X-ACTO Quiet Pro 35ct', ScanAction.Outgoing, -20, DateTime.now()),
    ScanEvent("NLH200001", 444999000, 'Crayola Washable Markers 100ct', ScanAction.Incoming, 15, DateTime.now()),
  ];

  @override
  int get rowCount => _scanEvents.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index > rowCount)
      return null;

    final ScanEvent scanEvent = _scanEvents[index];

    return DataRow(
      cells: <DataCell>[
        DataCell(Text(scanEvent.scanTime.toString())), // replace with formatted time
        DataCell(Text(scanEvent.gateId)),
        DataCell(Text(scanEvent.productId.toString())),
        DataCell(Text(scanEvent.productName)),
        DataCell(Text(scanEvent.action.name)),
        DataCell(Text(scanEvent.quantity.toString())),
      ],
    );
  }
}

final ScanHistoryDataSource _scanHistoryDataSource = ScanHistoryDataSource();

class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  _ScanHistoryPageState createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
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
        source: _scanHistoryDataSource,
        columns: const <DataColumn2>[
          DataColumn2(
            label: Text('Timestamp'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Gate ID'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Product ID'),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text('Product Name'),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text('Action'),
            size: ColumnSize.S,
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
