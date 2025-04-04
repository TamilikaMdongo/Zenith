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
                         // return ListTile(
                           // title: Text(eventTitle), // Display event title
                            //subtitle: Text(eventLocation),
                             // Display event location
                          //); // ListTile ends
                               // ignore: unnecessary_null_comparison
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




/*
 // Function to convert Base64 string to an image
  
  
  final db = FirebaseFirestore.instance;
  String? eventID;
  String? eventTitle;
  String? eventImagebase64;
  
Future <void> getPreviewData() async{
  DocumentSnapshot eventDetails = await db.collection('Event').doc('yp1kcvm1DNwG8B7e2akZ').get();
  setState(() {
       eventImagebase64 = eventDetails.get('eventImage');
   eventTitle = eventDetails.get('title');
  });

  Uint8List _decodeBase64(eventImagebase64) {
    return base64Decode(eventImagebase64);
  }
}

@override
 void initState() {
    super.initState();
    getPreviewData(); // Fetch event data when the screen is initialized
  }

  void doNothing() {}
*/

/*
 @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: 30,
              width: 200.0,
              decoration: const BoxDecoration(color: Colors.white),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.only(right: 50)),
              )),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 10),
            child: CircleAvatar(
              radius: 20,
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
            ),
          )
        ],
      ),
      // sidebar widget
      drawer: Drawer(
        backgroundColor: Colors.blue,
        // creates a list of all the items in the sidebar/drawer
        child: ListView(
          padding: EdgeInsets.zero,
          // the children of the listview
          children: <Widget>[
            DrawerHeader(child: Text('data')),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.white),
              title: const Text(
                'My Events',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              title: const Text(
                'Discover',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
          ],
        ),
      ),
      body: ListView(children: [
        SizedBox(
          height: 50.0,
        ),
        Column(children: <Widget>[
          // category buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('All Categories'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('Concert'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('Entertainment'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('Business'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('All Categories'),
                )
              ],
            ),
          ),
          const SizedBox(height: 30.0),

          GestureDetector( onTap: () {
            if (eventTitle != null && eventImagebase64 != null) {
                    // Decode the Base64 string to image
                    

                    // Navigate to the SelectedEvent widget and pass the data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedEvent(
                          eventTitle: eventTitle!,
                          eventImage: eventImagebase64
                        ),
                      ),
                    );
                  }
          },
            child: DisplayEvents(
                image:
                    'https://images.unsplash.com/photo-1742199009963-c028d0c5a603?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                title: 'Art Show',
                description:
                    'For all our Art fans please come by downtown for our exclusive art showcase',
                venue: 'Joburg Downtown',
                date: '5 February'),
          ),
          DisplayEvents(
              image:
                  'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWVyY2VkZXN8ZW58MHx8MHx8fDA%3D',
              title: 'Art Show',
              description:
                  'For all our Art fans please come by downtown for our exclusive art showcase',
              venue: 'Joburg Downtown',
              date: '5 February'),
          DisplayEvents(
              image:
                  'https://images.unsplash.com/photo-1742505709449-fa7df02e0164?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw4fHx8ZW58MHx8fHx8',
              title: 'Art Show',
              description:
                  'For all our Art fans please come by downtown for our exclusive art showcase',
              venue: 'Joburg Downtown',
              date: '5 February'),
        ]),
      ]),
    );
   
  }
*/