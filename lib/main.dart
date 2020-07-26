import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:doctor_app/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_app/patient.dart';
import 'package:doctor_app/patientList.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor APP',
      theme: ThemeData(
        // This is the theme of your application.
        //
        accentColor: Colors.white70,
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: 'Doctor App'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}
SharedPreferences sharedPreferences ;
class _MainPageState extends State<MainPage> {

  void initState(){
    super.initState();
    CheckLoginStatus();
  }
  CheckLoginStatus() async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('accessToken') == null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()),(route) => false);
    }
  }

  ///////////////////
  List<Patient> parsePatients(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Patient>((json) => Patient.fromJson(json)).toList();
  }

  Future<List<Patient>> fetchPatients() async {
    String token = sharedPreferences.getString('accessToken');
    final response = await http.post('http://bbb9ababee97.ngrok.io/auth/waitinglist',headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer '+token
    });

    // compute function to run parsePosts in a separate isolate
    return parsePatients(response.body);
  }
  /////////////////////

  createAlertDialog(BuildContext context,String content){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text(content),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    TextEditingController nameController = new TextEditingController();
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Doctor App'),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {

              fetchPatients();
            },
          )
        ],
      ),
      body: FutureBuilder<List<Patient>>(
        future: fetchPatients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ListViewPatients(patients: snapshot.data) // return the ListView widget
              : Center(child: CircularProgressIndicator());
        },
      ),
    );

  }

}