import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapService {
  static Future<Position> getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location Not Avalible");
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future getAddress() async {
    try {
      Position position = await getPosition();
      List<Placemark> placeMark = await GeocodingPlatform.instance
          .placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMark[0];
      return "${place.locality} ${place.subLocality} ${place.country} ${place.street}";
    } catch (e) {
      print(e);
    }
  }

  static Future displayAddress(double lat, double long) async {
    try {
      List<Placemark> placeMark =
          await GeocodingPlatform.instance.placemarkFromCoordinates(lat, long);
      Placemark place = placeMark[0];
      return "${place.locality} ${place.subLocality} ${place.country} ${place.street}";
    } catch (e) {
      Future.error(e);
    }
  }
}
