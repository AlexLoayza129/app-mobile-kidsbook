import 'package:api_consumo/views/home/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//Views
import 'package:api_consumo/views/authenticate/sign_in.dart';
import 'package:api_consumo/views/home/home.dart';


class EditProfile extends StatelessWidget {

  late var user;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  EditProfile(Object userInfo){
    this.user = userInfo;
  }
  
  //Alert
  Future<void> _showMyDialog(context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Datos Guardados Correctamente!', textAlign: TextAlign.center,),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('Aceptar')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        backgroundColor: Color.fromARGB(255, 32, 190, 132),
        title: Center(
          child: Text('Edita tu perfil', textAlign: TextAlign.center,style: TextStyle(
                    fontFamily: "Netflix",
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: 0.0,
                    color: Colors.white,
          )),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 50)),
            Center(child: Text('Nombre Actual', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix', color: Color.fromARGB(255, 0, 0, 0)))),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Center(child: Text('${this.user['nombres']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix', color: Color.fromARGB(255, 32, 190, 132)))),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            // Nuevo Correo
            Center(child: Text('Nuevo nombre', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix', color: Color.fromARGB(255, 0, 0, 0)))),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value){
                if(value == null || value == ''){
                  return;
                }
                this.user['nombres'] = value;
              },
            ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            // Guardar correo
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              onPressed: () async{
              
                // Obtenemos el DocId
                var docId = this.user['id'];

                _firestore.doc('users/$docId').update({
                    'nombres': this.user['nombres'],
                });


                await _showMyDialog(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(this.user)));
              },
              child: Text('Guardar')
            ),
            //Volver
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 24, 163, 137),
                padding: const EdgeInsets.symmetric(horizontal: 58, vertical: 15),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(this.user)));
              },
              child: Text('Volver')
            ),
        ]
      )),
    );
  }

}