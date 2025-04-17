import 'dart:convert';
import 'dart:typed_data';

import 'package:app/screens/widgets/selected_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:app/screens/widgets/display_events.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 final db = FirebaseFirestore.instance;
  Uint8List _decodeBase64(String base64String) {
    return base64Decode(base64String);
  }
   String? firstName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch the current user's first name from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
     print("Logged in UID: ${user.uid}");
      DocumentSnapshot userSnapshot = await db.collection('Users').doc().get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          firstName = userData['firstName'];  
        });
          
        
      }
    }
  }
  bool work =true;
 @override 
 Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white.withOpacity(0.8),
      shadowColor: Colors.white,
      bottomOpacity: 0,forceMaterialTransparency: true,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left:300.0, top: 10),
        child: Icon(Icons.notifications),
      ),
    ),
    
    drawer: Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top:100.0, left: 50.0, ),
        child: const Text('Coming Soon', style: TextStyle(fontSize: 25.0),),
      ),

    ),
    body: 
      SafeArea(
        child: 
           
             

             Column(
               children: [
                SizedBox(height: 40,),
                  Text(
                  'Welcome, ',
                  style: TextStyle(fontSize: 18),
                ),
                firstName != null
                  ? Text(
                      firstName!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'username loading...',
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                 Expanded(
                   child: StreamBuilder<QuerySnapshot>(
                      stream: db.collection('Event').snapshots(),
                    
                    builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                         if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text("No event data found"));
                      }
                      
                        var eventData = snapshot.data!.docs;
                       //String eventTitle =eventData['title'];
                      return ListView.builder(
                   
                        itemCount: eventData.length, // Total number of events
                        itemBuilder: (context, index) {
                          var events = eventData[index].data() as Map<String, dynamic>; // Convert to Map
                          String eventTitle = events['title'] ?? "No Title"; // Get event title
                          String eventLocation = events['location'] ?? "No Location"; // Get event location
                          String eventImagebase64 = events['eventImage'];
                          String price = events['ticketPrice'];
                          String eventDate = events['date'];
                          Uint8List imagebytes = _decodeBase64(eventImagebase64);
                        String eventId = eventData[index].id;
                         
                               if (eventId.isEmpty || eventId == null) {
                      // Handle the case where eventId is empty
                      return Center(child: Text('Event ID is missing.'));
                    }
                          else{
                          return Column(
                            children: [
                              
                               
                              
                             
                           
                              GestureDetector(
                                
                                onTap: (){
                                  print(eventId);
                                
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedEvent(eventImage: imagebytes, eventTitle: eventTitle, eventId:eventId, price: price, venue: eventLocation, date: '',)));
                                },
                                child: DisplayEvents(image:imagebytes, title: eventTitle, venue: eventLocation, date: eventDate, price: price,))
                    
                                
                            ],
                          );}
                        }, // itemBuilder function ends
                      ); 
                    }),
                 ),
               ],
             ),
            ),
       
        
   
  );
 }
}



