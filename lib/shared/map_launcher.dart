import 'package:maps_launcher/maps_launcher.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';

class MapLauncher {
  MapLauncher._();

  static launch(ChatGeolocationDto coordinates) {
    MapsLauncher.launchCoordinates(coordinates.latitude, coordinates.longitude);
  }
}
