import 'package:flutter/material.dart';
import 'patient.dart';

class ListViewPatients extends StatelessWidget {
  final List<Patient> patients;

  ListViewPatients({Key key, this.patients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: patients.length,
          padding: const EdgeInsets.all(20.0),
          itemBuilder: (context, position) {
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

  void _onTapItem(BuildContext context, Patient patient) {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text(patient.id.toString() + ' - ' + patient.name)));
  }
}