class Area {
  final String name;
  final String location;
  // Add more fields as needed

  Area({required this.name, required this.location});

  // Factory constructor for creating a new Area object from a map
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      name: json['name'],
      location: json['location'],
      // add more fields as needed
    );
  }
}
