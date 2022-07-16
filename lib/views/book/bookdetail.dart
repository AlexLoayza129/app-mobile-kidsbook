import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:api_consumo/views/home/home.dart';

class BookDetail extends StatelessWidget{
  dynamic book;

  //TODO: Enviar al firestore el libro favorito y en la vista fav mostrar los libros que tenga el usuario

  BookDetail(dynamic book){
    this.book = book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Color.fromARGB(255, 32, 190, 132),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Image.network(book.image)
            ),
            Text('${book.title}', style: TextStyle(color: Color.fromARGB(255, 32, 190, 132), fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Netflix'),),
            Padding(padding: EdgeInsets.all(20),
              child: Text('${book.subtitle}', style: TextStyle(color: Color.fromARGB(255, 29, 28, 28), fontSize: 15, fontFamily: 'Netflix'),),
            ),
            Padding(padding: EdgeInsets.all(20),
              child: Text('Precio: ${book.price}', style: TextStyle(color: Color.fromARGB(255, 133, 21, 123), fontSize: 20, fontFamily: 'Netflix'),),
            ),
          ],
        )
      ),
    );
  }
}
