
class Patient implements Comparable<Patient>{
  final int id;
  final String name;
  final int position;
  final String summary;

  Patient({this.id, this.name,this.position,this.summary});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as int,
      position: json['position'] as int,
      name: json['name'] as String,
      summary: json['summary'] as String
    );
  }

  @override
  int compareTo(Patient p) {
    if(this.position < p.position){
      return 1;
    }else{
      return 0;
    }
  }

}