import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget{
  @override
  _SignInState createState() => _SignInState();
}

//Get data of API
class getData{

  getData(){
  }

  Future getStatusCode(url) async {
    Uri APIURL = Uri.parse(url);
    final response = await http.get(APIURL);
    if (response.statusCode == 200) {
      return true;
    } else {
      return 'Failed to fetch books :( !';
    }
  }

}


class EmailFieldValidator{

  static validate(String value){
    return value.isEmpty ? 'Ingrese su correo' : null;
  }
}

class PasswordFieldValidator{

  static validate(String value){
    return value.isEmpty ? 'Ingrese su contraseña' : null;
  }
}

// Home
class _SignInState extends State<SignIn>{

  final frases = [
    '"Los libros son las abejas que llevan el polen de una inteligencia a otra"...',
    '“En algún lugar de un libro, hay una frase esperándonos para darle sentido a la existencia”...',
    '“Cuando terminas un buen libro no se acaba. Se esconde adentro tuyo”...',
    '“El autor sólo escribe la mitad de un libro. De la otra mitad debe ocuparse el lector”...',
  ];

  String correo = '';
  String password = '';
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  
  // Metodo para sortear las frases cada vez que el usuario entre
  String sortFrases(){
    var random = Random().nextInt(this.frases.length);
    return this.frases[random];
  }

  //Alert
  Future<void> _showMyDialog() async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Datos incorrectos!', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Ingrese correctamente sus datos'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Contenido de la vista de Logeo
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70.0,
        backgroundColor: Color.fromARGB(255, 32, 190, 132),
        title: Center(
          child: Text('KidsBook', textAlign: TextAlign.center,style: TextStyle(
                    fontFamily: "Netflix",
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
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
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField( // Input para el correo
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Correo'
                ),
                validator: (email){
                  EmailFieldValidator.validate(email.toString());
                  this.correo = email.toString();
                  return null;
                }
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField( // Validar la contraseña
                obscureText: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Contraseña'
                ),
                validator: (password){
                  PasswordFieldValidator.validate(password.toString());
                  this.password = password.toString();
                  return null;
                },
              ),
            ),
            SizedBox(height: 60.0),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 71, 174, 126),
                      Color.fromARGB(255, 64, 222, 167),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 64, 222, 167).withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]
                ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: InkWell(
                    onTap: () async {
                            if(_formKey.currentState!.validate()){ 
                              if(this.correo == '' || this.password == ''){
                                  _showMyDialog();
                                  return;
                              }
                              dynamic user = await _auth.signInWithEmailAndPassword(email: this.correo, password: this.password);

                              var id = user.user.uid;
                              var data = await _firestore.collection('users').where('id', isEqualTo: id).get();

                              final userInfo = data.docs[0].data();

                              if(user != null){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => LogInHome(this.correo,userInfo)
                                ));
                              }
                            } 
                        },
                      child: GestureDetector(
                      child: Text(
                        'Ingresar',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Netflix",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  )
                ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 174, 43, 222),
                      Color.fromARGB(255, 118, 44, 191),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 174, 43, 222).withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]
                ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: GestureDetector(
                    child: Text(
                      'Registrate',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Netflix",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.0,
                        color: Colors.white,
                      ),
                    ),
                    ),
                  )
                  ),
                ),
            ),
            ], // Children
          )
        ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Color.fromARGB(255, 32, 190, 132),
            child: Padding(
              child: Text(sortFrases(), 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Netflix",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.0,
                  color: Colors.white)),
              padding: EdgeInsets.symmetric(vertical: 25.0),
            ),
            elevation: 10.0,
          ),
        ),
    );
  }

} 


// Create
class Register extends StatelessWidget{

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _registerKey = GlobalKey<FormState>();
  
  late String nombres;
  late String apellidos;
  late String correo;
  late String password;

  //Alert
  Future<void> _showMyDialog(context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Datos incorrectos!', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('¡Ingrese correctamente los datos!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Center(child: Text('Aceptar')),
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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Registrate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      ),
      body: Form(
        key: _registerKey,
        child: Column(
          children: <Widget>[
            Padding( // Nombres
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nombres' 
                ),
                validator: (nombres) {
                  if(nombres == null || nombres.isEmpty){
                    return 'Ingresa tu nombre';
                  }
                  this.nombres = nombres; // Guardamos el nombre
                  return null;
                },
              ),
            ),
            Padding( // Apellidos
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Apellidos' 
                ),
                validator: (apellidos) {
                  if(apellidos == null || apellidos.isEmpty){
                    return 'Ingresa tu apellido';
                  }
                  this.apellidos = apellidos; // Guardamos el apellido
                  return null;
                },
              ),
            ),
            Padding( // Correo
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Correo' 
                ),
                validator: (correo) {
                  if(correo == null || correo.isEmpty){
                    return 'Ingresa tu correo';
                  }
                  this.correo = correo; // Guardamos el apellido
                  return null;
                },
              ),
            ),
            Padding( // Password
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Contraseña' 
                ),
                validator: (password) {
                  if(password == null || password.isEmpty){
                    return 'Ingresa tu contraseña';
                  }
                  this.password = password; // Guardamos el apellido
                  return null;
                },
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20 )),
            // Registrarse
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 40.0),
              ),
              onPressed: () async{
                if(_registerKey.currentState!.validate()){

                    final newUser = await _auth.createUserWithEmailAndPassword(email:this.correo, password:this.password);
                    
                    final newUserId = newUser.user?.uid;

                    _firestore.doc('users/$newUserId').set({
                      'nombres': this.nombres,
                      'apellidos': this.apellidos,
                      'correo': this.correo,
                      'id': newUserId,
                      'favorite-books': [],
                    });

                    if(newUser == null){
                      return;
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));

                }else{
                    _showMyDialog(context);
                }
              },
              child: Text('Enviar')
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10 )),
            //Volver
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 67, 207, 123),
                padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 40.0),
              ),
              onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
              },
              child: Text('Volver')
            ),
          ],
        ),
      ),
    );
  }
}
