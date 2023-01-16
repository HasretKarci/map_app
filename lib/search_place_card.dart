import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/GuidenceMarker.dart';
import 'package:map_app/bottom_marker_detail.dart';
import 'package:map_app/googlemap.dart';

class SearchPlaceCard extends StatelessWidget {
  GuidenceMarker? marker;

  SearchPlaceCard({this.marker});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
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
            child: Row(
              children: [
                Image.network(
                  marker!.imageUrl!,
                  height: 90,
                  width: 160,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(marker!.name!),
                )
              ],
            ),
          )),
    );
  }
}
