import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// fetch event data from firebase
// map through it 
// display it in a list tile
// event must be relevant to the user

class MyEvents extends StatefulWidget {
  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {

  final db = FirebaseFirestore.instance;
 // Function to convert Base64 string to an image
  Uint8List _decodeBase64(String base64String) {
    return base64Decode(base64String);
  }
String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;  // Return the user ID
  }
  @override
  Widget build(BuildContext context) {

    String? currentUserId = getCurrentUserId();

    if (currentUserId == null) {
      // If no user is logged in, show a message
      return Scaffold(
        body: Center(child: Text('Please log in to view events')),
      );
    }

    return Scaffold(
      body: StreamBuilder(
        stream: db.collection('Event').where('userId', isEqualTo: currentUserId).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No events available'));
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var event = snapshot.data!.docs[index];
                String base64String = event['eventImage'] ?? '';  // Get the Base64 string from Firestore
              Uint8List imageBytes = _decodeBase64(base64String);  // Convert the Base64 string to bytes
              return Column(
                children: [

                  Container(
                    height: 100.0,
                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                     decoration: BoxDecoration(
                      color: Colors.black
                     ),
                    child: ListTile(
                       leading: imageBytes.isNotEmpty
                          ? Image.memory(imageBytes, height: 50, width: 50, fit: BoxFit.cover) // Display the image
                          : Icon(Icons.image, color: Colors.white), // Placeholder if no image
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(event['title'], style: TextStyle(color: Colors.white),),
                      ),
                      subtitle: Text(event['location']),
                      trailing: Text(event['ticketPrice']),
                      onTap: () {
                        // Navigate to event details if needed
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
   
  }
}
