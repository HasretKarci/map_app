import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_app/GuidenceMarker.dart';
import 'package:map_app/getGuidence.dart';
import 'package:map_app/googlemap.dart';
import 'package:map_app/location_service.dart';
import 'package:map_app/near_places_section.dart';
import 'package:map_app/search_screen_view.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  static HomeState? instance;
  GoogleMapController? googleMapController;

  static List<GuidenceMarker> guidanceMarkers =
      List<GuidenceMarker>.empty(growable: true); // Tüm markerların listesi

  @override
  void initState() {
    super.initState();
    instance = this; // Son oluşturulan sınıf nesnesi
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map_rounded)),
              Tab(icon: Icon(Icons.view_list_rounded)),
            ],
          ), // tabbar
          title: const Text('DUX'),
        ),
        body: TabBarView(
          physics: new NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.67,
                    child: GoogleMapWidget(),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: NearPlacesSection(),
                    ),
                  )
                ],
              ),
            ),
            SearchScreen(),
          ],
        ),
      ),
    );
  }
}
