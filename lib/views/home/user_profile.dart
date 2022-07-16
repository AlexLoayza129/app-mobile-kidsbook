import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//Views
import 'package:api_consumo/views/authenticate/sign_in.dart';
import 'package:api_consumo/views/home/home.dart';
import 'package:api_consumo/views/home/profile/edit_profile.dart';
import 'favorite_section.dart';

class UserProfile extends StatelessWidget {

  //String correo = '';
  late var user;
  String nombres = '';
  String apellidos = '';
  String correo = '';

  UserProfile(Object userInfo){
    this.user = userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        backgroundColor: Color.fromARGB(255, 32, 190, 132),
        title: Center(
          child: Text('User Profile', textAlign: TextAlign.center,style: TextStyle(
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
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            CircleAvatar(
              maxRadius: 100.0,
              backgroundImage: NetworkImage('https://www.w3schools.com/w3css/img_avatar3.png'),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            // User Name
            Text('Nombre de usuario', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix')),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Text('${this.user['nombres']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix', color: Color.fromARGB(255, 32, 190, 132))),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            // Correo
            Text('Correo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix')),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Text('${this.user['correo']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix', color: Color.fromARGB(255, 32, 190, 132))),
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
              onPressed: (){ 
                Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => EditProfile(this.user)),
                );
              },
              child: Text('Editar nombres', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix', color: Colors.white))),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
          child: BottomAppBar(
            color: Color.fromARGB(255, 32, 190, 132),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Home View
                  IconButton(icon: Icon(Icons.home),color: Colors.white, 
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => LogInHome(this.user['correo'], this.user)),
                        );
                      },
                    ),
                  // User Profile
                  IconButton(icon: Icon(Icons.person),color: Colors.white, 
                    onPressed: () {
                      },
                    ),
                  // Favorite Books
                  IconButton(icon: Icon(Icons.local_library_rounded),color: Colors.white, onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteSection(this.user)));
                  },),
                  // Logout
                  IconButton(icon: Icon(Icons.logout),color: Colors.white, 
                    onPressed: () async{
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                    },),
                ],
              ),
              shape: CircularNotchedRectangle(),
          ),
      ),
    );
  }
}