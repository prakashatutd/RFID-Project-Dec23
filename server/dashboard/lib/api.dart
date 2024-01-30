import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'data_definitions.dart';

// Main entry point into the back-end API
class InventoryControlSystemAPI {
  static const String _baseUrl = '127.0.0.1:8000';
  static const String _apiRoot = '/api/';
  static const String _productsEndpoint = _apiRoot + 'products/';
  static const String _historyEndpoint = _apiRoot + 'history/';

  late final _httpClient = http.Client();

  // Private methods

  Future<http.Response> _makeGetRequest(String endpoint, Map<String, String> queryParameters) async {
    // Build request URL
    final url = Uri.http(_baseUrl, endpoint, queryParameters);

    // Issue request
    final response = await _httpClient
      .get(url, headers: { HttpHeaders.contentTypeHeader : 'application/json'})
      .timeout(Duration(seconds: 10));

    if (response.statusCode != 200)
      throw "Bad response!"; // placeholder, replace with exception

    return response;
  }

  // Public methods

  Future<ListResponse<Product>> getProducts(ListQueryParameters queryParameters) async {
    final response = await _makeGetRequest(_productsEndpoint, queryParameters.asMap());
    
    // Deserialize JSON response
    final Map<String, dynamic> responseJson = jsonDecode(response.body);
    final List<dynamic> results = responseJson['results'] as List<dynamic>;

    return ListResponse<Product>(
      responseJson['count'] as int,
      List<Product>.from(results.map((dynamic productJson) => Product.fromJson(productJson))),
    );
  }

  Future<ListResponse<ScanEvent>> getScanEvents(ListQueryParameters queryParameters) async {
    final response = await _makeGetRequest(_historyEndpoint, queryParameters.asMap());

    final Map<String, dynamic> responseJson = jsonDecode(response.body);
    final List<dynamic> results = responseJson['results'] as List<dynamic>;

    return ListResponse<ScanEvent>(
      responseJson['count'] as int,
      List<ScanEvent>.from(results.map((dynamic scanEventJson) => ScanEvent.fromJson(scanEventJson))),
    );
  }
}

// Represents REST API list query parameters
class ListQueryParameters {
  int? limit;
  int? offset;
  String? category;
  String? ordering;
  String? search;

  ListQueryParameters({
    this.limit,
    this.offset,
    this.category,
    this.ordering,
    this.search,
  });

  Map<String, String> asMap() {
    var queryParameters = Map<String, String>();

    if (limit != null)
      queryParameters['limit'] = limit!.toString();

    if (offset != null)
      queryParameters['offset'] = offset!.toString();
        
    if (category != null)
      queryParameters['category'] = category!;

    if (ordering != null)
      queryParameters['ordering'] = ordering!;

    if (search != null)
      queryParameters['search'] = search!;
    
    return queryParameters;
  }
}

// Encapsulates the response to a REST list GET request
class ListResponse<T> {
  int totalCount;  // total number of results
  List<T> results; // subset of results returned

  ListResponse(this.totalCount, this.results) {
  }
}