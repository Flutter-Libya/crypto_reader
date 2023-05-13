import 'package:http/http.dart' as http;
import 'dart:convert';
class CryptoData {
  Future<double> getCoinData(String crypto, String currency) async {
    http.Response response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/$crypto/$currency?apikey=F2AC6DFD-B95A-4911-8C6C-63431861A585');
    if (response.statusCode == 200) {
      String data = response.body;
      var rate = jsonDecode(data)["rate"];
      return rate;
    } else {
      print(response.statusCode);
      return null;
    }
  }
}
