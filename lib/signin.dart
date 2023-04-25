// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'viewprofile.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SignIn> createState() => _SignInState();
  }

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController studentidController = TextEditingController();
    Future <void> _getUser() async {
    final response = await http.get(Uri.parse('https://ashconnect.uc.r.appspot.com/Users?student_id=${studentidController.text}'));
    if (response.statusCode == 200){
            Navigator.push(
        context,       
       MaterialPageRoute(
          builder: (context) => ViewProfilePage(studentid: studentidController.text, title: 'View Profile'),
        ),);

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in. Create a profile.')));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xfff24867),
        centerTitle: true,
        title: Row(
          children: [
            Icon(
              Icons.login,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text('Sign In')
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.0),
                    const Icon(Icons.person_outlined, color:Color(0xfff24867), size: 140,),
                    Text(
                      'Sign In to Continue',
                      style: TextStyle(
                        color: Color(0xfff24867),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: TextFormField(
                        controller: studentidController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Student ID',
                          labelStyle: TextStyle(
                            color: Color(0xfff24867),
                          ),
                          prefixIcon: Icon(Icons.numbers_sharp, color: Color(0xfff24867),
                          ),
                          
                        ),
                         validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your StudentID';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: ()  {
                        if (_formKey.currentState!.validate()){

                          _getUser();
                        //
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        
                        backgroundColor: Color(0xfff24867),
                        padding: EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
