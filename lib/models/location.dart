class Location {
  final int id;
  final String displayName;
  Location({required this.id, required this.displayName});

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
