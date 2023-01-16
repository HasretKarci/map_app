class GuidenceMarker {
  double? latitude;
  double? longitude;
  int? id;
  String? name;
  String? description;
  String? icon;
  double? distance;
  bool isShowen = false;
  String? imageUrl;
  String? youtubeId;

  GuidenceMarker(
      {this.id,
      this.latitude,
      this.longitude,
      this.name,
      this.description,
      this.distance,
      this.icon,
      this.imageUrl,
      this.youtubeId});
}
