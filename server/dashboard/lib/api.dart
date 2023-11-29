import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Encapsulates the response to a REST list get request
class ListResponse<T> {
  int totalCount;  // total number of results
  List<T> results; // subset of results returned

  ListResponse(this.totalCount, this.results) {
  }
}

class Product {
  final int id;
  final String name;
  final String category;
  final int reorderPoint;
  int quantity;

  Product(
    this.id,
    this.name,
    this.category,
    this.reorderPoint,
    this.quantity
  );

  Product.fromJson(Map<String, dynamic> json)
    : id           = json['id']       as int,
      name         = json['name']     as String,
      category     = json['category'] as String,
      reorderPoint = json['rop']      as int,
      quantity     = json['quantity'] as int;
}

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

class InventoryControlSystemAPI {
  static const String _baseUrl = '127.0.0.1:8000';
  static const String _apiRoot = '/api/';
  static const String _productsEndpoint = _apiRoot + 'products/';

  late final _httpClient = http.Client();

  // Possibility of race condition?
  Map<String, String> _productsQueryParameters = {};

  Future<ListResponse<Product>> getProducts(int? limit, int? offset, String? category, String? ordering, String? search) async {
    if (limit != null)
      _productsQueryParameters['limit'] = limit.toString();

    if (offset != null)
      _productsQueryParameters['offset'] = offset.toString();
        
    if (category != null)
      _productsQueryParameters['category'] = category;

    if (ordering != null)
      _productsQueryParameters['ordering'] = ordering;

    if (search != null)
      _productsQueryParameters['search'] = search;

    // Build request URL
    final url = Uri.http(_baseUrl, _productsEndpoint, _productsQueryParameters);

    // Issue request
    final response = await _httpClient
      .get(url, headers: { HttpHeaders.contentTypeHeader : 'application/json'})
      .timeout(Duration(seconds: 10));

    if (response.statusCode != 200)
      throw "Bad response!"; // placeholder, replace with exception
    
    // Deserialize JSON response
    final Map<String, dynamic> responseJson = jsonDecode(response.body);
    List<dynamic> results = responseJson['results'] as List<dynamic>;

    return ListResponse<Product>(
      responseJson['count'] as int,
      List<Product>.from(results.map((dynamic productJson) => Product.fromJson(productJson))),
    );
  }

  // Future<ListResponse<ScanEvent>> getScanEvents(int? limit, int? offset) async {

  // }
}