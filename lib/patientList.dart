import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'patient.dart';
import 'package:doctor_app/removePatient.dart';

class ListViewPatients extends StatefulWidget {
  final List<Patient> patients;

  const ListViewPatients({Key key, this.patients}) : super(key: key);
  @override
  _ListViewPatients createState() => _ListViewPatients(patients);

}

class _ListViewPatients extends State<ListViewPatients>{

  final List<Patient> patients;

  _ListViewPatients(this.patients);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(

          itemCount: patients.length,
          padding: const EdgeInsets.all(20.0),
          itemBuilder: (context, position) {
            patients.sort((a,b)=> a.position.compareTo(b.position));
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${patients[position].name}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 22.0,
                        child: Text(
                          '${patients[position].position}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () => _onTapItem(context, patients[position]),
                ),
              ],
            );
          }),
    );
  }

  void _onTapItem(BuildContext context, Patient patient) async{
    if(patient.position == 1){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences.setInt("position", patient.position);
        sharedPreferences.setString("name", patient.name);
        sharedPreferences.setInt("id", patient.id);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => RemovePatient(patient.name,patient.position,patient.summary)),(route) => true);
      });
    }else{
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text(patient.position.toString() + ' - ' + patient.name+', Sorry you can only choose the first patient')));
    }
  }


}