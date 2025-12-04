

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class InternetChecker {
  static Future<bool> hasGoodInternetConnection() async {
    if (kIsWeb)
    {
      return true;
    }
    // Check connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No WiFi or mobile data
      return false;
    }

    // Perform a test to verify internet access
    try {
      final response = await http.get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(milliseconds: 5000));
      print("response status code : ${response.statusCode}");
      if (response.statusCode == 200) {
        // Successful response indicates good internet
        return true;
      }
    } catch (e) {
      // If request fails or times out, assume no internet
      return false;
    }

    return false;
}
}