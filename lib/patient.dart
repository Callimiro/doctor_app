
class Patient {
  final int id;
  final String name;
  final int position;

  Patient({this.id, this.name,this.position});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as int,
      position: json['position'] as int,
      name: json['name'] as String,
    );
  }
}