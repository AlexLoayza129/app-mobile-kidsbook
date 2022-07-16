import 'package:api_consumo/views/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget{
    @override
    Widget build(BuildContext){
        
        // Retornara entre la vista Home o lo enviará a la autenticación
        return Authenticate();
    }
}