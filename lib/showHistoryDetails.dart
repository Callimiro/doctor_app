import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/patientHistory.dart';
import 'package:flutter/material.dart';


class ShowPatientHistory extends StatefulWidget {
  PatientHistory patientHistory;

  ShowPatientHistory(this.patientHistory);

  _ShowPatientHistory createState() => _ShowPatientHistory(patientHistory);
}
class _ShowPatientHistory extends State<ShowPatientHistory>{
   PatientHistory patientHistory;
   String injury;
   TextEditingController resumeController = new TextEditingController();
  _ShowPatientHistory(this.patientHistory);

   initState(){
     resumeController.text = patientHistory.doctor_resume;
     switch(patientHistory.injurity){
       case 1:
         injury = "general";
         break;
       case 2:
         injury = "Intergast";
         break;
       case 3:
         injury = "Orl";
         break;
       case 4:
         injury = "Cardio";
         break;
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Patient History'),
        actions: <Widget>[
        ],
      ),
      body: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              readOnly: true,

              decoration: new InputDecoration(
                  hintText: 'Patient name: '+patientHistory.name,
                  hintStyle: TextStyle(color: Colors.black)
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.healing),
            title: new TextField(
              readOnly: true,

              decoration: new InputDecoration(
                  hintText: 'doctor name: '+patientHistory.doctor_name,
                  hintStyle: TextStyle(color: Colors.black)
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.airline_seat_flat),
            title: new TextField(
              readOnly: true,

              decoration: new InputDecoration(
                  hintText: 'severity: '+patientHistory.severity.toString(),
                  hintStyle: TextStyle(color: Colors.black)
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.airline_seat_flat),
            title: new TextField(
              readOnly: true,

              decoration: new InputDecoration(
                  hintText: 'injury type: '+injury,
                  hintStyle: TextStyle(color: Colors.black)
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.airline_seat_flat),
            title: new TextField(
              readOnly: true,

              decoration: new InputDecoration(
                  hintText: 'Date: '+patientHistory.created_at.toString(),
                  hintStyle: TextStyle(color: Colors.black)
              ),
            ),
          ),
          new ListTile(
              leading: const Icon(Icons.markunread_mailbox),
              title: new TextField(
                controller: resumeController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                readOnly: true,
                decoration: new InputDecoration(
                    hintText: patientHistory.doctor_resume.toString(),
                    hintStyle: TextStyle(color: Colors.black)
                ),
              )
          ),
        ],
      ),

    );
  }

}
