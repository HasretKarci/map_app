import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:map_app/GuidenceMarker.dart';

class GetGuidance {
  List<GuidenceMarker> places = [];

  Future<void> getPlaces() async {
    DatabaseReference _testRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await _testRef.get();
    var jsonData = await json.decode(json.encode(snapshot.value));
    var placesData = jsonData["places"];
    placesData.forEach((obj) {
      GuidenceMarker guidanceModel = GuidenceMarker(
          id: obj["id"],
          name: obj["name"],
          latitude: obj["latitude"],
          longitude: obj["longitude"],
          description: obj["description"],
          distance: obj["distance"],
          icon: obj["icon"],
          imageUrl: obj["imageUrl"],
          youtubeId: obj["youtubeId"]);
      places.add(guidanceModel);
    });
  }
}
