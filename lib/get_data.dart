import 'package:http/http.dart' as http;
import 'dart:convert';

//https://rest.coinapi.io/v1/exchangerate/BTC/INR?apikey=APIKEY

class NetworkHelper {
  final String from_curr;
  final String to_curr;

  NetworkHelper({required this.from_curr, required this.to_curr});

  Future getData() async {
    var url = Uri.https(
      "rest.coinapi.io",
      "/v1/exchangerate/$from_curr/$to_curr",
      {
        'apikey': 'Your coinapi API_KEY here!',
      },
    );

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
