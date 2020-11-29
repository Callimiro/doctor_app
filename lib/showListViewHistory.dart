
import 'dart:convert';

import 'package:doctor_app/patientHistory.dart';
import 'package:doctor_app/patientHistoryList.dart';
import 'package:doctor_app/removePatient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


class ShowListViewHistory extends StatefulWidget{

  @override
  _ShowListViewHistory createState() => _ShowListViewHistory();
}

class _ShowListViewHistory extends State<ShowListViewHistory>{
  SharedPreferences sharedPreferences;
  List<PatientHistory> patientHistories;

  List<PatientHistory> parsePatients(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PatientHistory>((json) => PatientHistory.fromJson(json)).toList();
  }
  Future<List<PatientHistory>> getPatientHistory() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('accessToken');
    String name = sharedPreferences.getString('name');

    var response = await http.post("http://240aedc662a2.ngrok.io/api/auth/patientHistory",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer '+token
        },body: json.encode(<String, String>{
          'name':name,
        }));
    print(parsePatients(response.body));
    patientHistories = parsePatients(response.body);
    return patientHistories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History List'),
        actions: <Widget>[

        ],
      ),
      body: new FutureBuilder<List<PatientHistory>>(
        future: getPatientHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ListViewHistory(patientHistories: snapshot.data) // return the ListView widget
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

}