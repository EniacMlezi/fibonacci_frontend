import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/fibonacci_request.dart';

abstract class FibonacciService {
  ///Request the [n]th number in the Fibonacci sequence.
  Future<String?> getFibonacci(int n);

  ///Request a history of all previous [getFibonacci] requests.
  Future<List<FibonacciRequest>> getHistory();

  ///Request a specific page of previous [getFibonacci] requests.
  Future<List<FibonacciRequest>> getHistoryPage(
      int pageSize, int? startFromDateTime);
}

class ApiFibonacciService implements FibonacciService {
  ///Request the [n]th number in the Fibonacci sequence.
  @override
  Future<String?> getFibonacci(int n) async {
    try {
      var url = Uri.parse("$fibonacciApiUrl/Fibonacci?n=$n");
      var response = await http.get(url);
      return response.body;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<FibonacciRequest>> _getHistory(Uri url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonRequests = jsonDecode(response.body);
        return List.generate(jsonRequests.length,
            (index) => FibonacciRequest.fromJson(jsonRequests[index]));
      }
    } catch (e) {
      log(e.toString());
    }
    return List.empty();
  }

  ///Request a history of all previous [getFibonacci] requests.
  @override
  Future<List<FibonacciRequest>> getHistory() async {
    var url = Uri.parse("$fibonacciApiUrl/Fibonacci/History");
    return _getHistory(url);
  }

  ///Request a specific page of previous [getFibonacci] requests.
  @override
  Future<List<FibonacciRequest>> getHistoryPage(
      int pageSize, int? startFromId) {
    String urlString = "$fibonacciApiUrl/Fibonacci/History/$pageSize";
    if (startFromId != null) {
      urlString += "/$startFromId";
    }

    var url = Uri.parse(urlString);
    return _getHistory(url);
  }
}
