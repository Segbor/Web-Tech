// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'viewprofile.dart';




  

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CreateProfile> createState() => _CreateProfileState();
  }

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController studentidController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController favfoodController = TextEditingController();
  TextEditingController favmovieController = TextEditingController();
  //TextEditingController residenceController = TextEditingController();
  TextEditingController yeargroupController = TextEditingController();
  
  var _selectedmajor;
  
  var _selectedresidence;
  //TextEditingController majorController = TextEditingController();



  Future<void> _createProfile() async {
    final url = Uri.parse('https://ashconnect.uc.r.appspot.com/Users');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',//ask about the header whether having diff datatypes in the field and my header being set to string is a problem
      },
      body: jsonEncode(<String, dynamic>{
        'student_id': studentidController.text,
        'name': nameController.text,
        'email': emailController.text,
        'dob': dobController.text,
        'favorite_food': favfoodController.text,
        'favorite_movie': favmovieController.text,
        'residence': _selectedresidence,
        'major': _selectedmajor,
        'yeargroup': yeargroupController.text,


      }),
    );
    // ask about how to let it not navigate to the app page if the profile was not created
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile created successfully')));
      Navigator.push(
        context,       
       MaterialPageRoute(
          builder: (context) => ViewProfilePage(studentid: studentidController.text, title: 'View Profile'),
        ),).then((value) => setState((){}));
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create profile. Try again later.')));
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
              Icons.create_sharp,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text('Create')
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
                      'Build your Profile',
                      style: TextStyle(
                        color: Color(0xfff24867),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xfff24867)),
        borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Name',
        labelStyle: TextStyle(
        color: Color(0xfff24867),
        ),
        prefixIcon: Icon(Icons.person_outline, color: Color(0xfff24867)),
        ),
        validator: (value) {
        if (value?.isEmpty ?? true) {
        return 'Please enter your name';
        }
        return null;
        },
        ),
      ),
      
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Color(0xfff24867),
                          ),
                          prefixIcon: Icon(Icons.email_outlined, color: Color(0xfff24867),),
                        ),
                         validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                      ),
                    ),
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
                        keyboardType: TextInputType.number,
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
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: TextFormField(
                        controller: dobController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Date of birth',
                          labelStyle: TextStyle(
                            color: Color(0xfff24867),
                          ),
                          prefixIcon: Icon(Icons.calendar_month, color: Color(0xfff24867),),
                        ),
                        
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedmajor,
                          onChanged: (value) {
                            setState(() {
                              _selectedmajor = value;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'MIS',
                              child: Text('Management Information Systems'),
                            ),
                            DropdownMenuItem(
                              value: 'CS',
                              child: Text('Computer Science'),
                            ),
                            DropdownMenuItem(
                              value: 'BA',
                              child: Text('Business Administration'),
                            ),
                            DropdownMenuItem(
                              value: 'EE',
                              child: Text('Electrical/Electronic Engineering'),
                            ),
                            DropdownMenuItem(
                              value: 'CE',
                              child: Text('Computer Engineering'),
                            ),
                            DropdownMenuItem(
                              value: 'ME',
                              child: Text('Mechanical Engineering'),
                            ),
                          ],
                          //controller: majorController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Major',
                            labelStyle: TextStyle(
                              color: Color(0xfff24867),
                            ),
                            prefixIcon: Icon(Icons.school, color: Color(0xfff24867),),
                          ),
                           validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your major';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: TextFormField(
                        controller: yeargroupController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Year Group',
                          labelStyle: TextStyle(
                            color: Color(0xfff24867),
                          ),
                          prefixIcon: Icon(Icons.book, color: Color(0xfff24867),),
                        ),
                         validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your yeargroup';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: TextFormField(
                        controller: favfoodController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Favorite food',
                          labelStyle: TextStyle(
                            color: Color(0xfff24867),
                          ),
                          prefixIcon: Icon(Icons.food_bank, color: Color(0xfff24867),),
                        ),
                         validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your favorite food';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      child: TextFormField(
                        controller: favmovieController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Favorite Movie',
                          labelStyle: TextStyle(
                            color: Color(0xfff24867),
                          ),
                          prefixIcon: Icon(Icons.movie, color:Color(0xfff24867) ,),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your favorite movie';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                       width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff24867)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                        child: DropdownButtonFormField<String>(
                        value: _selectedresidence,
                        onChanged: (value) {
                          setState(() {
                            _selectedresidence = value;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'On-Campus',
                            child: Text('On-Campus'),
                          ),
                          DropdownMenuItem(
                            value: 'Off-Campus',
                            child: Text('Off-Campus'),
                          ),
                        ],
                  
                        //controller: residenceController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Residence',
                          labelStyle: TextStyle(
                            color: Color(0xfff24867),
                          ),
                          prefixIcon: Icon(Icons.home, color: Color(0xfff24867),), 
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your residence';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: ()  {
                        if (_formKey.currentState!.validate()){

                          _createProfile();
                        // TODO: Implement create profile functionality
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
                        'Create Profile',
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
