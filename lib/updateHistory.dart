
import 'dart:convert';

import 'package:doctor_app/updatePatient.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateHistory extends StatefulWidget{
  @override
  _UpdateHistory createState() => _UpdateHistory();

}

class _UpdateHistory extends State<UpdateHistory>{
  SharedPreferences sharedPreferences;
  TextEditingController nameController = new TextEditingController();
  TextEditingController resumeController = new TextEditingController();
  createAlertDialog(BuildContext context,String content){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text(content),
      );
    });
  }
  lookUpPatientHistory(String name,String resume) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('accessToken');
    var response = await http.post("http://240aedc662a2.ngrok.io/api/auth/updatePatientHistory",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer '+token
        },body: json.encode(<String, String>{
          'name':name,
          'resume':resume
        }));
    if(response.statusCode == 200 && response.body == "good"){
      createAlertDialog(context, "patient history updated !");
    }else{
      createAlertDialog(context, "patient does not exist or never been in your waiting queue.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Patient History'),
      ),
      body: ListView(
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            margin: EdgeInsets.only(top: 30.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Patient name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: resumeController,
              decoration: InputDecoration(
                hintText: 'Doctor resume',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            margin: EdgeInsets.only(top: 30.0),
            child: RaisedButton(
              onPressed: (){
                if(nameController.text != null && resumeController.text != null){
                  lookUpPatientHistory(nameController.text,resumeController.text);
                }else{
                  createAlertDialog(context, "you need to specify a Patient name and a to fill the resume.");
                }
              },
              child: Text("Update",style: TextStyle(color: Colors.white70)),
              color: Colors.green,

            ),
          )
        ],
      ),
    );
  }

}