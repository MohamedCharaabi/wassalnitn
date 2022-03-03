import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Future<List?> getAdress(String term) async {
    try {
      http.Response _response = await http.get(
          Uri.parse(
              'https://api.radar.io/v1/search/autocomplete?query=$term&country=tn&limit=3'),
          headers: {
            'Authorization':
                'prj_test_pk_8531c1a80d96a5d9c199dcb6ce741bdc8444f3be',
          });

      if (_response.statusCode == 200) {
        //  return json.decode(_response.body)['results'];
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      return null;
    }
  }
}
