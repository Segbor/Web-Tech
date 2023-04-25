// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trial/viewprofile.dart';

import 'feed.dart';

class EditProfilePage extends StatefulWidget {
  final String studentid;
  EditProfilePage({required this.studentid, required String title});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _studentidController;
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _dobController;
  TextEditingController? _favfoodController;
  TextEditingController? _favmovieController;
  TextEditingController? _residenceController;
  TextEditingController? _majorController;
  TextEditingController? _yeargroupController;

  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfilePage(studentid: widget.studentid, title: 'View Profile'),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedPage(studentid: widget.studentid,),
          ),
        );
        break;
      case 3:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Create Post'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Post'),
              ),
            ],
          ),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }




  void _getUser() async {
final response = await http.get(Uri.parse('https://ashconnect.uc.r.appspot.com/Users?student_id=${widget.studentid}'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _studentidController = TextEditingController(text: json['student_id']);
        _nameController = TextEditingController(text: json['name']);
        _emailController = TextEditingController(text: json['email']);
        _dobController = TextEditingController(text: json['dob']);
        _favfoodController = TextEditingController(text: json['favorite_food']);
        _favmovieController = TextEditingController(text: json['favorite_movie']);
        _residenceController = TextEditingController(text: json['residence']);
        _majorController = TextEditingController(text: json['major']);
        _yeargroupController = TextEditingController(text: json['yeargroup']);
      });
    }
  }


    Future<void> _updateUser() async {
final url =  Uri.parse('https://ashconnect.uc.r.appspot.com/Users?student_id=${widget.studentid}');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',//ask about the header whether having diff datatypes in the field and my header being set to string is a problem
      },
      body: jsonEncode(<String, dynamic>{
        'student_id': _studentidController!.text,
        'name': _nameController!.text,
        'email': _emailController!.text,
        'dob': _dobController!.text,
        'favorite_food': _favfoodController!.text,
        'favorite_movie': _favmovieController!.text,
        'residence': _residenceController!.text,
        'major': _majorController!.text,
        'yeargroup': _yeargroupController!.text,
      }),
    );

        if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile. Try again later.')));
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
        appBar: AppBar(
        backgroundColor: Color(0xfff24867),
        centerTitle: true,
        title: Row(
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text('Edit')
          ],
        ),
      ),
    body: Row(
      children: [
        NavigationRail(
            leading: Text('AshConnect',style: TextStyle(color:Color(0xfff24867) ,fontWeight: FontWeight.bold),),
            extended: true,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemSelected,
            labelType: NavigationRailLabelType.none,
            
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person,color:Color(0xfff24867) ,),
                label: Text('Profile', style: TextStyle(color: Color(0xfff24867),),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feed, color: Color(0xfff24867),),
                label: Text('Feed', style: TextStyle(color: Color(0xfff24867)),),
              ),
                NavigationRailDestination(
                icon: Icon(Icons.favorite, color: Color(0xfff24867),),
                label: Text('Favorites', style: TextStyle(color: Color(0xfff24867)),),
              ),
                 NavigationRailDestination(
                icon: Icon(Icons.post_add, color: Color(0xfff24867),),
                label: Text('Post', style: TextStyle(color: Color(0xfff24867)),),
              ),
            ],

            
          ),
          
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40.0),
                  const Icon(Icons.person_outlined, color:Color(0xfff24867), size: 140,),
                  Text(
                    'Edit Your Profile',
                    style: TextStyle(
                      color: Color(0xfff24867),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Name'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xfff24867)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xfff24867)),
                                    ),
                                  ),
                                  controller: _nameController,
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                         Flexible(
                          child: SizedBox(width: 10,),
                        ),
                        
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Email'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xfff24867)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xfff24867)),
                                    ),
                                  ),
                                  controller: _emailController,
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: SizedBox(width: 10,),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Date of Birth'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xfff24867)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xfff24867)),
                                    ),
                                  ),
                                  controller: _dobController,
                                  readOnly: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                         Flexible(
                          child: SizedBox(width: 10,),
                        ),
                        
                      ],
                      
                      
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Year Group'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                ),
                                controller: _yeargroupController,
                                readOnly: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Flexible(
                        child: SizedBox(width: 10,),
                      ),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Major'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                ),
                                controller: _majorController,
                                readOnly: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SizedBox(width: 10,),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Fav food'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                ),
                                controller: _favfoodController,
                                readOnly: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Flexible(
                        child: SizedBox(width: 10,),
                      ),
                      
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Fav movie'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                ),
                                controller: _favmovieController,
                                readOnly: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Flexible(
                        child: SizedBox(width: 10,),
                      ),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Residence'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                ),
                                controller: _residenceController,
                                readOnly: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SizedBox(width: 10,),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Student ID'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xfff24867)),
                                  ),
                                ),
                                controller: _studentidController,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Flexible(
                        child: SizedBox(width: 10,),
                      ),
                   
                    ],
                  ),
                     SizedBox(height: 30,),
                      ElevatedButton(
                            onPressed: ()  {
                              _updateUser().then((value){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewProfilePage(studentid: widget.studentid, title: 'View Profile')));
        
                              });
                             //do something
                            },
                            style: ElevatedButton.styleFrom(
                              
                              backgroundColor: Color(0xfff24867),
                              padding: EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              'Update Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      SizedBox(height: 30,)
                ],
                
              ),
              
            ),
            
          ),
        ),
      ],
    ),
  );
}
}