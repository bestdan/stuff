class Location {
  final int id;
  final String displayName;
  final List<Location> subLocations;
  Location(
      {required this.id,
      required this.displayName,
      this.subLocations = const <Location>[]});

  void addSubLocation(Location location) {
    subLocations.add(location);
  }

  void removeSubLocation(Location location) {
    subLocations.remove(location);
  }

  Location? getSubLocation(int id) {
    for (var location in subLocations) {
      if (location.id == id) {
        return location;
      }
      var subContainer = location.getSubLocation(id);
      if (subContainer != null) {
        return subContainer;
      }
    }
    return null;
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as int,
      displayName: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': displayName};
  }
}
