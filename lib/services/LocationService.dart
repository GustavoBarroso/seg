import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getLocalizacaoAtual() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
