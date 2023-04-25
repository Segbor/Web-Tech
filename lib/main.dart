// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trial/signin.dart';
import 'createprofile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions options=FirebaseOptions(
    apiKey: 'AIzaSyAGsMIocyrtsLx_tCNasvA_oRlTYUT2hb0',
    appId: '1:445096783555:web:03b10e2db25ac5b988bc76',
    messagingSenderId: '445096783555',
    projectId: 'ashconnect',
    authDomain: 'ashconnect.firebaseapp.com',
    databaseURL: 'https://ashconnect-default-rtdb.firebaseio.com',
    storageBucket: 'ashconnect.appspot.com',
    measurementId: 'G-JG7LYLPPEZ',
  );
  
  await Firebase.initializeApp( options:options);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF4165),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            Text(
              'Hey There!!',
              style: GoogleFonts.courgette(
                fontSize: 50.0,
                color: Colors.white,
                 letterSpacing: 4.0,
              ),
            ),
            SizedBox(height: 80.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProfile(title: 'Profile',)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
               child: Text(
                'Create Profile',
                textAlign: TextAlign.center,
                style: GoogleFonts.courgette(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn(title: 'Profile',)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
               child: Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: GoogleFonts.courgette(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
