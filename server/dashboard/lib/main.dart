import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'inventory_page.dart';
import 'trends_page.dart';
import 'orders_page.dart';
import 'scan_history_page.dart';


class InventoryItem {
  final String id;
  final String name;

  InventoryItem({required this.id, required this.name});
}

class InventoryProvider extends ChangeNotifier {
  List<InventoryItem> _items = [];

  List<InventoryItem> get items => _items;

  Future<void> fetchInventoryItems() async {
    try {
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        // Assume the JSON response is an array of objects with 'id' and 'name' properties
        List<dynamic> data = json.decode(response.body);
        _items = data.map((item) => InventoryItem(id: item['id'], name: item['name'])).toList();
        notifyListeners(); // Call notifyListeners() to update the UI
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var inventoryProvider = Provider.of<InventoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            inventoryProvider.fetchInventoryItems();
          },
          child: const Text('Fetch Inventory Items'),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InventoryProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InventoryPage(),
        routes: {
          '/inventory': (context) => InventoryPage(),
          '/trends': (context) => TrendsPage(),
          '/orders': (context) => OrdersPage(),
          '/ScanHistory': (context) => ScanHistoryPage(),
        },
      ),
    ),
  );
}