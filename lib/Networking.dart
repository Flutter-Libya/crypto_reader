import 'package:http/http.dart' as http;
import 'dart:convert';

class TheData {
  Future<double> getCoinData() async {
    http.Response response = await http.get(
        "https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=F2AC6DFD-B95A-4911-8C6C-63431861A585");
    if (response.statusCode == 200) {
      String data = response.body;
      var rate = jsonDecode(data)["rate"];
      return rate;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }
}
