import 'package:doctor_app/patientHistory.dart';
import 'package:doctor_app/showHistoryDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'patient.dart';
import 'package:doctor_app/removePatient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListViewHistory extends StatefulWidget {
  final List<PatientHistory> patientHistories;


  const ListViewHistory({Key key,this.patientHistories}) : super(key: key);
  @override
  _ListViewHistory createState() => _ListViewHistory(patientHistories);

}

class _ListViewHistory extends State<ListViewHistory>{

  _ListViewHistory(this.patientHistories);
  SharedPreferences sharedPreferences;
  List<PatientHistory> patientHistories;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView.builder(

          itemCount: patientHistories.length,
          padding: const EdgeInsets.all(20.0),
          itemBuilder: (context, position) {
            //patientHistories.sort((a,b)=> a.created_at.compareTo(b.created_at));
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${patientHistories[position].created_at}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  onTap: () => _onTapItem(context,patientHistories[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, PatientHistory patientHistories) async{
    print(patientHistories.created_at);
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ShowPatientHistory(patientHistories)),(route) => true);
    });
  }


}