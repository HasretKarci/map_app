import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/GuidenceMarker.dart';
import 'package:map_app/bottom_marker_detail.dart';
import 'package:map_app/googlemap.dart';

class PlaceCard extends StatelessWidget {
  GuidenceMarker? marker;

  PlaceCard({this.marker});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        GoogleMapWidgetState.instance!
            .CameraZoom(LatLng(marker!.latitude!, marker!.longitude!), 18),
        showModalBottomSheet(
            isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (context) => BottomMarkerDetail(
                  marker: marker,
                ))
      },
      child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          child: Container(
            child: Column(
              children: [
                Image.network(
                  marker!.imageUrl!,
                  height: 90,
                  width: 160,
                  fit: BoxFit.cover,
                ),
                Text(marker!.name!)
              ],
            ),
          )),
    );
  }
}
