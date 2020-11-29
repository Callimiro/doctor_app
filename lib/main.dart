import 'dart:convert';

import 'package:doctor_app/updateHistory.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:doctor_app/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_app/patient.dart';
import 'package:doctor_app/patientList.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/removePatient.dart';

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

class _MainPageState extends State<MainPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String title = "Title";
  String helper = "helper";
  SharedPreferences sharedPreferences;

  setFirebaseTokent(fb_token)async{
    print("the fire base token is ...........");
    print(fb_token);
    String firebaseToken = fb_token;
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("firebaseToken", firebaseToken);
  }

  void initState(){
    super.initState();
    _firebaseMessaging.getToken().then((fb_token){
      setFirebaseTokent(fb_token);
    });
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async{
          setState(() {
            fetchPatients();
          });
          print('onMessage : $message');
        },
        onLaunch: (Map<String, dynamic> message) async{
          setState(() {
            fetchPatients();
          });
          print('onMessage : $message');
        },
        onResume: (Map<String, dynamic> message) async{
          setState(() {
            fetchPatients();
          });
          print('onMessage : $message');
        }
    );
    CheckLoginStatus();
    fetchPatients();
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
    final response = await http.post('http://240aedc662a2.ngrok.io/auth/waitinglist',headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer '+token
    });

    // compute function to run parsePosts in a separate isolate
    List<Patient> patietns = parsePatients(response.body);
    print(patietns.first.position);
    patietns.sort((a,b)=> a.position.compareTo(b.position));
    print(patietns.first.position);
    return patietns;
  }
  /////////////////////

  createAlertDialog(BuildContext context,String content){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text(content),
      );
    });
  }
  firebaseTokenUnregistration() async{
    String fb_token =sharedPreferences.getString("firebaseToken");
    String token = sharedPreferences.getString('accessToken');
    var response = await http.post("http://240aedc662a2.ngrok.io/api/auth/firebase_token_unregistration",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          //'Authorization': 'Bearer '+token
        },body: json.encode(<String, String>{
          'firebaseToken':fb_token,
          'authorization':token
        }));
    if(response.statusCode == 200){
      setState(() {
        sharedPreferences.setString("accessToken", null);
      });
    }
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
              setState((){
                fetchPatients();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.find_replace),
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UpdateHistory()),(route) => true);
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              firebaseTokenUnregistration();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()),(route) => true);
            },
          ),
        ],
      ),
      body: new FutureBuilder<List<Patient>>(
        future: fetchPatients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
              ? new ListViewPatients(patients: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );

  }

}