import 'dart:convert';

import 'package:doctor_app/patientHistory.dart';
import 'package:doctor_app/patientHistoryList.dart';
import 'package:doctor_app/showListViewHistory.dart';
import 'package:doctor_app/updatePatient.dart';
import 'package:flutter/material.dart';
import 'patient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/main.dart';


class RemovePatient extends StatefulWidget {
  String name;
  int position;
  String nurse_summary;

  RemovePatient(this.name, this.position, this.nurse_summary);

  _RemovePatient createState() => _RemovePatient(name,position,nurse_summary);
}
  class _RemovePatient extends State<RemovePatient>{
    _RemovePatient(this.name, this.position, this.nurse_summary);

    String name;
    int position;
    String nurse_summary;
  SharedPreferences sharedPreferences;
  getInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //name = sharedPreferences.getString("patientName");
    //position = sharedPreferences.getInt("patientPosition");
  }
  confirm()async{
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('accessToken');
    var response = await http.post("http://240aedc662a2.ngrok.io/api/auth/patient_treated",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer '+token
        },body: json.encode(<String, Object>{
          'position':position,
          'name':name,
          'summary':summaryController.text
        }));
    print(response.body);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()),(route) => false);
  }


  TextEditingController summaryController = new TextEditingController();
    List<PatientHistory> parsePatients(String responseBody) {
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
      return parsed.map<PatientHistory>((json) => PatientHistory.fromJson(json)).toList();
    }
  setName()async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('name', name);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: const Text('Treat patient'),
        actions: <Widget>[
          RaisedButton(
            child: Text("Show History",style: TextStyle(color: Colors.white70)),
            color: Colors.blue,
            onPressed: () {
              setState(()  {
                setName();
              });
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ShowListViewHistory()),(route) => true);
            },
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.perm_identity),
            title: new TextField(
              readOnly: true,

              decoration: new InputDecoration(
                  hintText: name,
                  hintStyle: TextStyle(color: Colors.blueGrey)
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.airline_seat_flat),
            title: new TextField(
              readOnly: true,

              decoration: new InputDecoration(
                  hintText: position.toString(),
                  hintStyle: TextStyle(color: Colors.blueGrey)
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.markunread_mailbox),
            title: new TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              readOnly: true,
              decoration: new InputDecoration(
                hintText: nurse_summary.toString(),
                hintStyle: TextStyle(color: Colors.blueGrey)
              ),
            )
          ),
          new ListTile(
            leading: const Icon(Icons.text_fields),
            title: new TextField(
              controller: summaryController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                  hintText: "Doctor summary",
              ),
            ),
          ),
          new RaisedButton(
            onPressed: () {
              confirm();
            },
            child: Text("Finish Treatment",style: TextStyle(color: Colors.white70)),
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),

        ],
      ),

    );
  }

}
