import 'package:api_consumo/views/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

const firebaseOptions = FirebaseOptions(
  appId: '1:1014491335205:android:3dead922a87099a3fc4dcc',
  apiKey: 'AIzaSyCgi-xrVlh9gOwOPLttoEQptsL2p27WVzQ',
  projectId: 'kidsbook-5d328',
  messagingSenderId: '1014491335205',
  authDomain: 'FIREBASE_AUTH_DOMAIN',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  runApp(KidsBook());
}

class KidsBook extends StatelessWidget {
   @override
   Widget build(BuildContext context){
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
      );
   }
}
