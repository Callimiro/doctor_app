
import 'package:flutter/cupertino.dart';

class PatientHistoryUpdate extends StatefulWidget{
  int id;
  int doctor_id;
  int Sevirity;
  int injurity;
  String name;
  String created_at;
  String doctor_resume;

  PatientHistoryUpdate(this.name,this.created_at,this.doctor_resume);
  @override
  _PatientHistory createState() => _PatientHistory(name,created_at,doctor_resume);
}

class _PatientHistory extends State<PatientHistoryUpdate>{

  String name;
  String created_at;
  String doctor_resume;
  _PatientHistory(this.name,this.created_at,this.doctor_resume);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}