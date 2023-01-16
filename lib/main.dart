import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _fbApp =
      Firebase.initializeApp(); // Firebase bağlantı

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // Ekran dönme engelleme
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("you have an error! " + '${snapshot.error.toString()}');
            return Text("something went wrong");
          } else if (snapshot.hasData) {
            return Home();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
