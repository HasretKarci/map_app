import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_app/GuidenceMarker.dart';
import 'package:map_app/bottom_marker_detail.dart';
import 'package:map_app/getGuidence.dart';
import 'package:map_app/home.dart';
import 'package:map_app/location_service.dart';
import 'package:map_app/near_places_section.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class GoogleMapWidget extends StatefulWidget {
  @override
  State<GoogleMapWidget> createState() => GoogleMapWidgetState();
}

class GoogleMapWidgetState extends State<GoogleMapWidget> {
  static GoogleMapWidgetState? instance;

  var initialCamera = CameraPosition(
      target: LatLng(37.939069, 27.3415384),
      zoom: 17); // uygulamanın başta fokuslanacağı konum

  GoogleMapController? googleMapController;
  //kullanıcıyı takip eden marker için liste
  Set<Marker> userMarkers = Set<Marker>();
  Set<Marker> markers = Set<Marker>();
  Set<Circle> circles = Set<Circle>();
  double? latitude, longitude; // yerlerin enlem boylam değerleri
  int checkDistance = 400; // dairenin yarıçapı
  List<GuidenceMarker>? nearGuidances =
      List<GuidenceMarker>.empty(growable: true); // yakındaki yerlerin listesi

  Timer? timer;
  Timer? nearPlacestimer;

  //bu google widget ekrana geldiğinde çalışan method
  @override
  void initState() {
    super.initState();
    //kullanıcının konumunu çekmek için method
    getLocation();
    getPlaces();
    //deneme için girilen eserleri ekleyen method
    instance = this;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => loopAllMarkers());
    //nearPlacestimer = Timer.periodic(Duration(seconds: 10), (Timer t) => loopNearPlaces());
  }

  @override
  void dispose() {
    googleMapController!.dispose();
    nearPlacestimer!.cancel();
    timer?.cancel();
    super.dispose();
  }

  void getPlaces() async {
    GetGuidance getGuidance = GetGuidance();
    await getGuidance.getPlaces();
    setState(() {
      HomeState.guidanceMarkers.clear();
      getGuidance.places.forEach((place) => {
            HomeState.guidanceMarkers.add(place),
            GoogleMapWidgetState.instance!.createMarker(
              place.id!.toString(),
              LatLng(place.latitude!, place.longitude!),
              place.name!,
              place.icon!,
              place.distance!,
            ),
          });
    });
  }

  void loopAllMarkers() {
    if (isShowingClosePlace) {
      return;
    }
    nearGuidances!.clear();

    HomeState.guidanceMarkers.forEach((mark) => checkMyDistance(
        mark,
        computeDistance(
            // uzaklığımızı hesapla tüm markerlar için
            mp.LatLng(userMarkers.first.position.latitude,
                userMarkers.first.position.longitude),
            mp.LatLng(mark.latitude!, mark.longitude!))));
    NearPlacesSectionState.instance!.setState(() {});
  }

  bool isShowingClosePlace = false; // üstüste binme engelleme

  void checkMyDistance(GuidenceMarker marker, double distance) {
    // her markerin uzaklığı buraya gönderiliyor belirlenen değerden düşük olanlar near places e gönderiliyor
    if (checkDistance > distance) {
      NearPlacesSectionState.instance!.setState(() {
        nearGuidances!.add(marker);
      });
    }
    if (distance < marker.distance! && !marker.isShowen) {
      // alana girince de gösteriyor
      isShowingClosePlace = true;
      marker.isShowen = true;
      showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          context: context,
          builder: (context) => BottomMarkerDetail(
                marker: marker,
              ));
    }

    isShowingClosePlace = false;
  }

  double computeDistance(mp.LatLng start, mp.LatLng end) {
    // herhangi iki marker arasındaki uzaklık
    num distanceBetweenPoints =
        mp.SphericalUtil.computeDistanceBetween(start, end);

    return distanceBetweenPoints.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.satellite,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: initialCamera,
          onMapCreated: (controller) => googleMapController = controller,
          markers: markers,
          circles: circles,
        ),
        Positioned(
          right: 12,
          bottom: 110,
          child: CircleAvatar(
              child: IconButton(
                  onPressed: () {
                    LatLng pos = new LatLng(latitude!, longitude!);
                    CameraZoom(pos, 17);
                  },
                  icon: Icon(Icons.my_location_rounded))),
        ),
      ],
    );
  }

  //tüm marker listelerinin birleştirmek için method
  CombineMarkers(Set<Marker> list) {
    list.forEach((element) {
      markers.add(element);
    });
  }

  @override
  void OnLongPress(LatLng pos) async {
    // bu test metodu kullanılmıyor
    try {
      createMarker("656", pos, "test", "ancient", 50);
    } catch (e) {}
  }

  void CameraZoom(LatLng latLng, double zoom) {
    // herhangi bir konuma fokus atan metot
    var cameraPos = CameraPosition(target: latLng, zoom: zoom);
    googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  //kullanıcı konumunu çekmek için
  void getLocation() async {
    userMarkers.clear();
    //konum servisi ve lokasyeon verisini çekmek için custom sınıf çağırımı
    final service = LocationService();
    final locationData = await service.getLocation();

    //kullanıcı konum verisini aktarma
    if (locationData != null) {
      latitude = locationData.latitude;
      longitude = locationData.longitude;

      LatLng pos = new LatLng(latitude!, longitude!);
      //kullanıcı takip marker başlatma
      await initUserMarker(pos);
      GoogleMapWidgetState.instance!.loopAllMarkers();
      //widget arayüzü güncelleme
      setState(() {
        CombineMarkers(userMarkers);
        CameraZoom(pos, 17);
      });

      //her lokasyon değişiminde çağırılacak method
      service.location.onLocationChanged
          .listen((LocationData currentLocation) async {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
        LatLng pos = new LatLng(latitude!, longitude!);

        //kullanıcı konum güncelleme
        Marker newMarker = Marker(
            markerId: MarkerId("0"),
            infoWindow: InfoWindow(title: "User"),
            icon: await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size(100, 100)), 'assets/person.png'),
            position: pos);

        setState(() {
          userMarkers.clear();
          userMarkers.add(newMarker);
          CombineMarkers(userMarkers);
          //CameraZoom(pos, 18);
        });
      });
    }
  }

  //kullanıcı konum başlatma
  initUserMarker(LatLng pos) async {
    Marker newUserMarker = Marker(
      markerId: MarkerId("0"),
      infoWindow: InfoWindow(title: "User"),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(100, 100)), 'assets/person.png'),
      position: pos,
    );
    userMarkers.add(newUserMarker);
  }

  createMarker(String id, LatLng pos, String title, String iconType,
      double radius) async {
    BitmapDescriptor icon;
    //ikon tipleri seçimi
    switch (iconType) {
      case "person":
        icon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/person.png');
        break;
      case "ancient":
        icon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/ancient.png');
        break;
      default:
        icon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(100, 100)), 'assets/pyramids.png');
        break;
    }
    Marker newMarker = Marker(
      markerId: MarkerId(id),
      infoWindow: InfoWindow(title: title),
      icon: icon,
      position: pos,
    );

    Circle newCircle = Circle(
        circleId: CircleId(id),
        center: pos,
        radius: radius,
        fillColor: Color.fromARGB(150, 255, 247, 97),
        strokeColor: Color.fromARGB(130, 255, 179, 15));

    setState(() {
      markers.add(newMarker);
      circles.add(newCircle);
    });
  }

  void markerTap() {
    showBottomSheet(context: context, builder: (context) => Container());
  }

  onMarkerTop() {}
}
