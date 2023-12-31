part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/province"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var job = json.decode(response.body);
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    return result;
  }

  static Future<List<City>> getCity(var provId) async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/city"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var job = json.decode(response.body);
    List<City> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCities = [];
    for (var c in result) {
      if (c.provinceId == provId) {
        selectedCities.add(c);
      }
    }

    return selectedCities;
  }

  static Future<List<Costs>> getCost(
      String origin, String destination, String weight, String courier) async {
    var response = await http.post(
      Uri.https(Const.baseUrl, "/starter/cost"),
      headers: <String, String>{
        'key': Const.apiKey,
      },
      body: <String, String>{
        'origin': origin,
        'destination': destination,
        'weight': weight,
        'courier': courier,
      },
    );

    var job = json.decode(response.body);
    List<Costs> result = [];

    if (response.statusCode == 200) {
      if (job['rajaongkir']['status']['code'] == 200) {
        List<dynamic> results = job['rajaongkir']['results'][0]['costs'];
        result = results.map((e) => Costs.fromJson(e)).toList();
        print(result);
      }
    }
    return result;
  }
}
