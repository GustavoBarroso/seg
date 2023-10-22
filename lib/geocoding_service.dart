import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
  final apiKey = 'SUA_CHAVE_DE_API_DO_GOOGLE_MAPS';
  final apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final results = data['results'] as List;
    if (results.isNotEmpty) {
      final addressComponents = results[0]['address_components'] as List;
      String formattedAddress = '';
      for (var component in addressComponents) {
        final types = component['types'] as List;
        if (types.contains('street_number')) {
          formattedAddress += component['long_name'] + ', ';
        } else if (types.contains('route')) {
          formattedAddress += component['long_name'] + ', ';
        } else if (types.contains('postal_code')) {
          formattedAddress += component['long_name'];
        }
      }
      return formattedAddress;
    }
  }
  return 'Endereço não encontrado';
}
