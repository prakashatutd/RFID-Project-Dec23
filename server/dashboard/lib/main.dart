import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api.dart';
import 'inventory_page.dart';
import 'trends_page.dart';
import 'orders_page.dart';
import 'scan_history_page.dart';

class _DashboardPage {
  final String name;
  final Icon icon;
  final Widget content;

  const _DashboardPage(this.name, this.icon, this.content);
}

InventoryControlSystemAPI api = InventoryControlSystemAPI();

List<_DashboardPage> _dashboardPages = <_DashboardPage>[
  _DashboardPage('Inventory', const Icon(Icons.list), InventoryPage(api)),
  _DashboardPage('History', const Icon(Icons.history), const ScanHistoryPage()),
  _DashboardPage('Trends', const Icon(Icons.timeline), const TrendsPage()),
  _DashboardPage('Orders', const Icon(Icons.local_shipping), const OrdersPage()),
  _DashboardPage('Gates', const Icon(Icons.sensors), const ScanHistoryPage()), // placeholder
];

final List<NavigationDrawerDestination> _navigationDrawerDestinations = _dashboardPages.map(
  (_DashboardPage page) {
    return NavigationDrawerDestination(
      label: Text(page.name),
      icon: page.icon,
    );
  }
).toList();

final List<NavigationRailDestination> _navigationRailDestinations = _dashboardPages.map(
  (_DashboardPage page) {
    return NavigationRailDestination(
      label: Text(page.name),
      icon: page.icon,
    );
  }
).toList();

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool mobileMode = MediaQuery.of(context).size.width < 640;

    return Scaffold(
      appBar: AppBar(
        title: Text(_dashboardPages[_pageIndex].name),
      ),
      body: mobileMode ? _buildMobileBody() : _buildDesktopBody(),
      drawer: mobileMode ? _buildDrawer() : null,
    );
  }

  Widget _buildMobileBody()
  {
    return _buildBodyContent();
  }

  Widget _buildDesktopBody()
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        NavigationRail(
          selectedIndex: _pageIndex,
          labelType: NavigationRailLabelType.all,
          destinations: _navigationRailDestinations,
          onDestinationSelected: _onDestinationSelected,
        ),
        Expanded(
          child: _buildBodyContent(),
        ),
      ],
    );
  }

  Widget _buildBodyContent() {
    return _dashboardPages[_pageIndex].content;
  }

  Widget _buildDrawer() {
    return NavigationDrawer(
      selectedIndex: _pageIndex,
      children: _navigationDrawerDestinations,
      onDestinationSelected: _onDestinationSelected,
    );
  }

  void _onDestinationSelected(int index) {
    if (index == _pageIndex)
      return;

    setState(() {
      _pageIndex = index;
    });
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const Dashboard(),
    )
  );
}