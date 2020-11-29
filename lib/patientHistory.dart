import 'package:cloud_firestore/cloud_firestore.dart';
class PatientHistory implements Comparable<PatientHistory>{
  final int id;
  final String name;
  final String doctor_name;
  final String doctor_resume;
  final int severity;
  final int injurity;
  final String created_at;

  PatientHistory({this.id, this.name, this.doctor_name, this.doctor_resume, this.severity, this.injurity, this.created_at});

  factory PatientHistory.fromJson(Map<String, dynamic> json) {
    return PatientHistory(
        id: json['id'] as int,
        name: json['name'] as String,
        doctor_name: json['doctor_name'] as String,
        doctor_resume: json['doctor_resume'] as String,
        severity: json['severity'] as int,
        injurity: json['injurity'] as int,
        created_at: json['created_at'] as String
    );

  }

  @override
  int compareTo(PatientHistory patientHistory) {
    return this.created_at.compareTo(patientHistory.created_at);
  }
}