// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trial/viewprofile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class FeedPage extends StatefulWidget {
  final String studentid;
  FeedPage({super.key, required this.studentid,});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
final TextEditingController _postController = TextEditingController();
final TextEditingController _emailController = TextEditingController();

  
  Future<void> _createPost() async {
    final url = Uri.parse('https://ashconnect.uc.r.appspot.com/Posts?student_id=${widget.studentid}');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',//ask about the header whether having diff datatypes in the field and my header being set to string is a problem
      },
      body: jsonEncode(<String, dynamic>{
        
        'Post': _postController.text,
        'email': _emailController.text,

      }),
    );
    // ask about how to let it not navigate to the app page if the profile was not created
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)

        .showSnackBar(SnackBar(content: Text('Post made!')));
          

    } else {
      ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(content: Text('Failed to create post. Try again later.')));
    }
  }

final postsRef = FirebaseFirestore.instance.collection('Posts');
late Stream<QuerySnapshot<Map<String, dynamic>>> postsStream;
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    labelText: 'Post',
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
                onPressed: ()async{
                  await _createPost();
                  Navigator.pop(context);
                } ,
                child: Text('Post'),
              ),
            ],
          ),
        );
        break;
    }
  }


Set<DocumentSnapshot> _likedPosts = Set<DocumentSnapshot>();

@override
void initState() {
  super.initState();
  postsStream = FirebaseFirestore.instance.collection('Posts').orderBy('timestamp',descending: true).snapshots();
}

// @override
// void initState() {
//   super.initState();
//   postsStream = postsRef.orderBy('timestamp',descending: true).snapshots();
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Social Media Feed'),
        backgroundColor: Color(0xffFF4165),
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
                label: Text('Profile', style: TextStyle(color: Color(0xfff24867),),),
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
          child: Container(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: postsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
        
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
        
            final posts = snapshot.data!.docs;
        
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                final post = posts[index].data();
                DateTime timestamp = post['timestamp'].toDate();
                String formattedTimestamp = DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp);

                bool isLiked = _likedPosts.any((doc) => doc.id == posts[index].id);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading:  Icon(Icons.person),
                        title: Text(post['email']),
                        subtitle: Text(formattedTimestamp),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          post['Post'],
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                            color: Color(0xfff24867),
                            onPressed: () {
                              setState(() {
                                final postDoc = posts[index];
                                if (isLiked) {
                                  _likedPosts.removeWhere((doc) => doc.id == postDoc.id);
                                  postDoc.reference.update({'likes': FieldValue.increment(-1)});
                                } else {
                                  _likedPosts.add(postDoc);
                                  postDoc.reference.update({'likes': FieldValue.increment(1)});
                                }
                              });
                            },
                          ),
                          Text('${post['likes']} likes'),

                    ],

                      )
                    ],
                  ),
                );
              },
            );
          },
          ),
        ),
        ),
      ],
    ),
);
}
}
