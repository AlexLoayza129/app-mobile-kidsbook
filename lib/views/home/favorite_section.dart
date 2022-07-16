import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:api_consumo/models/images.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//Views
import 'package:api_consumo/views/authenticate/sign_in.dart';
import 'package:api_consumo/views/home/user_profile.dart';
import 'package:api_consumo/views/home/home.dart';
import '../book/bookdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_icons/cupertino_icons.dart';


class FavoriteSection extends StatelessWidget{

  final _firestore = FirebaseFirestore.instance;
  late Future<List<Images>> _favList = getList();
  late dynamic user;
  late var bookId;

  FavoriteSection(dynamic userInfo){
    var userId = userInfo['id'];
    getUserInfo(userId);
  }

  getUserInfo(userId) async{
    this.user = await _firestore.doc('users/$userId').get();
  }

  Future<List<Images>> _getList() async {
    final response = await http.get(Uri.parse("https://api.itbook.store/1.0/search/kids"));

    List<Images> images = [];

    if (response.statusCode == 200) {

      String body = utf8.decode(response.bodyBytes);

      final jsonData = json.decode(body);
      var books = jsonData["books"];
      var favBooks =  this.user['favorite-books'];

      for (var i = 0; i < books.length; i++) {

        for(var k = 0; k < favBooks.length; k++){

          if(books[i]["isbn13"].toString() == favBooks[k].toString()){

            images.add(Images(books[i]["title"], books[i]["image"], books[i]["subtitle"], books[i]["price"], books[i]["url"], books[i]["isbn13"]));
          
          }

        }

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
          child: Text('My Favorite Books', textAlign: TextAlign.center,style: TextStyle(
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
            future: _favList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    crossAxisCount: 2, children: _listFavorite(snapshot.data, context));
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
                  IconButton(icon: Icon(Icons.home),color: Colors.white, onPressed: () {
                    Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context) => LogInHome(this.user['correo'], this.user)),
                      );
                  },),
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

   List<Widget> _listFavorite(data, context){
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
                        var newFav;
                        var newFavBooks = this.user['favorite-books'];

                        for(var i = 0; i < newFavBooks.length; i++){
                          if(newFavBooks[i] == bookId){
                            newFavBooks.removeAt(i);
                          }
                        }

                        _firestore.doc('users/${this.user['id']}').update({
                          'favorite-books': newFavBooks
                        });

                        Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteSection(this.user)));

                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.delete , color: Color.fromARGB(255, 188, 188, 188),)
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
    _favList = _getList();
    return _favList;
  }
}