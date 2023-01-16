import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:map_app/googlemap.dart';
import 'package:map_app/place_card.dart';

class NearPlacesSection extends StatefulWidget {
  @override
  State<NearPlacesSection> createState() => NearPlacesSectionState();
}

class NearPlacesSectionState extends State<NearPlacesSection> {
  static NearPlacesSectionState? instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instance = this;
  }

  @override
  Widget build(BuildContext context) {
    int _index = 0;
    return GoogleMapWidgetState.instance!.nearGuidances!.isEmpty
        ? Container(
            width: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                    child: Image.asset(
                  'assets/person.png',
                  height: 90,
                )),
                CircularProgressIndicator(),
              ],
            ))
        : Container(
            color: Color.fromARGB(255, 0, 0, 0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Yakındaki Eserler'),
                ),
                Container(
                  child: PageView.builder(
                    itemCount: GoogleMapWidgetState.instance!.nearGuidances!
                        .length, // google map wiget instance sindan yakındaki noktaların uzunluğunu çekiyoruz
                    controller: PageController(viewportFraction: 0.3),
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    itemBuilder: (_, i) {
                      return PlaceCard(
                        marker:
                            GoogleMapWidgetState.instance!.nearGuidances![i],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
