import 'package:flutter/material.dart';

import 'inventory_page.dart';
import 'trends_page.dart';
import 'orders_page.dart';
import 'scan_history_page.dart';

class _DashboardPageInfo {
  final String name;
  final Icon icon;
  final Widget page;

  const _DashboardPageInfo(this.name, this.icon, this.page);
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const List<_DashboardPageInfo> _pages = <_DashboardPageInfo>[
    _DashboardPageInfo('Inventory', Icon(Icons.list), const InventoryPage()),
    _DashboardPageInfo('History', Icon(Icons.history), const ScanHistoryPage()),
    _DashboardPageInfo('Trends', Icon(Icons.timeline), const TrendsPage()),
    _DashboardPageInfo('Orders', Icon(Icons.local_shipping), const OrdersPage()),
    _DashboardPageInfo('Gates', Icon(Icons.sensors), const ScanHistoryPage()), // placeholder
  ];
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_pageIndex].name),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NavigationRail(
            selectedIndex: _pageIndex,
            labelType: NavigationRailLabelType.all,
            destinations: _pages.map(
              (_DashboardPageInfo pageInfo) {
                return NavigationRailDestination(
                  label: Text(pageInfo.name),
                  icon: pageInfo.icon,
                );
              }
            ).toList(),
            onDestinationSelected: (int index) {
              setState(() {
                _pageIndex = index;
              });
            },
          ),
          Expanded(
            child: _pages[_pageIndex].page,
          ),
        ]
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: const Dashboard(),
    ),
  );
}