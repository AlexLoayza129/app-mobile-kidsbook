import 'dart:convert';
import 'package:api_consumo/views/home/favorite_section.dart';
import 'package:api_consumo/views/home/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/images.dart';
import 'package:api_consumo/views/authenticate/sign_in.dart';
import '../book/bookdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// READ
class LogInHome extends StatelessWidget{

  late String userId;
  late String nombres;
  late String apellidos;
  late String correo;
  late String password;
  late dynamic favoriteBooks;
  late Future<List<Images>> _listImages;
  late dynamic user;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  LogInHome(String correo, dynamic userInfo){
    getList();
    if(correo == null || correo == ''){
      return;
    }
    this.correo = correo;
    this.user = userInfo;
    this.userId = userInfo['id'];
    this.favoriteBooks = userInfo['favorite-books'];
  }

  Future<List<Images>> _getListBook() async {
    final response = await http.get(Uri.parse(
        "https://api.itbook.store/1.0/search/kids"));

    List<Images> images = [];

    if (response.statusCode == 200) {

      String body = utf8.decode(response.bodyBytes);

      final jsonData = json.decode(body);

      for (var item in jsonData["books"]) {
        images.add(Images(item["title"], item["image"], item["subtitle"], item["price"], item["url"], item["isbn13"]));
      }
      return images;
    } else {
      throw Exception("Fallo la conexión");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        backgroundColor: Color.fromARGB(255, 32, 190, 132),
        title: Center(
          child: Text('Kids Library', textAlign: TextAlign.center,style: TextStyle(
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
      body: FutureBuilder(
            future: _listImages,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    crossAxisCount: 2, children: _listaDeLibros(snapshot.data, context));
              }
              //Circulo de espera
              return Center(child: CircularProgressIndicator());
            }),
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
                  IconButton(icon: Icon(Icons.home),color: Colors.white, onPressed: () {},),
                  // User Profile
                  IconButton(icon: Icon(Icons.person),color: Colors.white, 
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => UserProfile(this.user)),
                        );
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


  List<Widget> _listaDeLibros(data, context) {
    List<Widget> books = [];
    for (var i = 0; i < data.length; i++) {
      books.add(
            Card(
             elevation: 10.0,
             child: InkWell(
              child: Column(
                children: [
                    Expanded(child: Image.network(data[i].image, fit: BoxFit.fill)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(data[i].title, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Netflix', fontWeight: FontWeight.w500),),
                    ),
                    InkWell(
                      onTap: (){
                        var bookId = data[i].isbn13;
                        var newFavBook = FieldValue.arrayUnion([bookId]);
                        _firestore.doc('users/$userId').update({
                          'favorite-books': newFavBook
                        });

                        this.user['favorite-books'].add(newFavBook);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.add , color: Color.fromARGB(255, 188, 188, 188),)
                      )
                    )
                  ],
                  ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetail(data[i])));
                },

              ),
             ),
      );
    }

    return books;
  }

  Future<List<Images>> getList(){
    _listImages = _getListBook();
    return _listImages;
  }

}

