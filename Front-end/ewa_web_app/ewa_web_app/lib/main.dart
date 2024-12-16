import 'package:ewa_web_app/screens/chat_screen.dart';
import 'package:ewa_web_app/screens/login_screen.dart';
import 'package:ewa_web_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBrV2cZb4o8JAksyKF7gq00wlktC_nqHUY",
          authDomain: "ewa-web-app.firebaseapp.com",
          projectId: "ewa-web-app",
          storageBucket: "ewa-web-app.appspot.com",
          messagingSenderId: "373731407511",
          appId: "1:373731407511:web:799949dec7b63df4771bd2",
          measurementId: "G-R1QQF7WG31"
      )
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Set HomeScreen as the initial screen
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}
