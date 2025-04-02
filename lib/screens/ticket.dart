import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid_v4/uuid_v4.dart';
/*
class MyTicketView extends StatefulWidget {
  const MyTicketView({Key? key}) : super(key: key);

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}
*/
class MyTicketView extends StatefulWidget {
  
  
  const MyTicketView({super.key});

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView> {
  @override
  Widget build(BuildContext context) {

    String? userId = FirebaseAuth.instance.currentUser?.uid;
if (userId == null) {
  return Center(child: Text("User not logged in"));
}


    return Scaffold(
      appBar: AppBar(title: const Text('My Ticket')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('Tickets')
          .where('userID', isEqualTo: userId)
          .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.docs.isNotEmpty) {
            return const Center(child: Text('No event found'));
          }
           var eventData = snapshot.data!.docs;
    return ListView.builder(
      itemCount: eventData.length,
      itemBuilder: (context, index){
         var ticketDoc = eventData[index];
         
          String ticketId = ticketDoc.id;
         Map<String, dynamic> ticketData = ticketDoc.data() as Map<String, dynamic>;
          
          
          String eventName = ticketData['eventName'] ?? 'Unknown Event';
          String organizer = ticketData['title'] ?? 'Unknown';
          String date = ticketData['eventDate'] ?? '01/01/01';
          String venue = ticketData['venue'] ?? 'Unknown Venue';
          String ticketNumber = ticketData['ticketNumber'] ?? '0000 1234 5678';
String truncateTicketNumber(String ticketNumber) {
  if (ticketNumber.length > 10) {
    return ticketNumber.substring(0, 5) + "..." + ticketNumber.substring(ticketNumber.length - 5);
  } else {
    return ticketNumber;
  }
}
          return Center(
            child: TicketWidget(
              width: 350,
              height: 450,
              isCornerRounded: true,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ticketDetailsWidget('Organizer', organizer, 'Date', date),
                  const SizedBox(height: 10),
                  ticketDetailsWidget('Venue', venue, 'Ticket No.', truncateTicketNumber(ticketNumber)),
                  
                  Padding(
                    padding: const EdgeInsets.only(left:80.0,),
                    child: QrImageView(data: ticketNumber, size: 150,),
                  )
      
                ],
              ),
            ),
          );}
          );
        },
      ),
    );
  }
}

Widget ticketDetailsWidget(String title1, String desc1, String title2, String desc2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title1, style: const TextStyle(color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(desc1, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(title2, style: const TextStyle(color: Colors.grey)),
          ),
          Text(desc2, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ],
  );
}

/*
class _MyTicketViewState extends State<MyTicketView> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: StreamBuilder<Object>(
        stream: db.collection('Event').doc().snapshots(),
        builder: (context, snapshot) {
          
          return Center(
            child: TicketWidget(
              width: 350,
              height: 550,
              isCornerRounded: true,
              padding: EdgeInsets.all(20),
              child: TicketData(),
            ),
          );
        }
      ),
    );
  }
}
*/

/*
class TicketData extends StatefulWidget {
  const TicketData({Key? key}) : super(key: key);

  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
 /* Map<String, dynamic>? eventData; // Stores event data from Firestore
  bool isLoading = true; // Loading state
  bool hasError = false; // Error state

  @override
  void initState() {
    super.initState();
    fetchEventData(); // Fetch event data when widget initializes
  }

  // Fetch the first event from Firestore (modify logic as needed)
  Future<void> fetchEventData() async {
    try {
      // Reference to the "Events" collection
      final db = FirebaseFirestore.instance.collection('Events');
    

      // Fetch the first event document (Modify query as needed)
      QuerySnapshot querySnapshot = await db.limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          eventData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true; // No events found
        });
      }
    } catch (e) {
      print("Error fetching event data: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }
*/
  @override
  Widget build(BuildContext context) {
   
  final db = FirebaseFirestore.instance;
    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('Events').doc('HR8XWfKfyScsrFhFRsH3').snapshots(),
      
      builder: (context, snapshot) {
        if(!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists){
          return Center(child: const Text('no event found'));
        }
        var ticketData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        String eventName = ticketData['title'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(width: 1.0, color: Colors.green),
                  ),
                  child: Center(
                    child: Text(
                      eventName, // Fetch ticket type
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                eventName, // Fetch event name
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ticketDetailsWidget(
                      'Organizer',
                      eventName,
                      'Date',
                      eventName),
                 /* Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ticketDetailsWidget(
                        'Venue',
                       // eventData?['venue'] ?? 'Unknown',
                        'Host',
                        'eventData?[host]'' '?? 'Unknown'),
                  ), */
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
              child: Container(
                width: 250.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://www.thechecker.net/hubfs/images/barcode.png'), // Fetch barcode
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 75.0, right: 75.0),
              child: Text(
              'ticketNumber' ?? '0000 1234 5678',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      }
    );
  }
}

// Ticket Details Widget (Reusable UI Component)
Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}

























/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyTicketView extends StatelessWidget {
  const MyTicketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: TicketWidget(
          width: 350,
          height: 550,
          isCornerRounded: true,
          padding: EdgeInsets.all(20),
          child: TicketData(),
        ),
      ),
    );
  }
}

class TicketData extends StatefulWidget {
  const TicketData({
    Key? key,
  }) : super(key: key);

  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
 
  Map<String, dynamic>? eventData; // Store event data
  bool isLoading = true; // Show loading state
  bool hasError = false; // Error state

   @override
  void initState() {
    super.initState();
    fetchEventData(); // Fetch event data on load
  }


  // Function to fetch a single event document
  Future<void> fetchEventData() async {
    try {
      // Get reference to the 'Events' collection
      final db = FirebaseFirestore.instance.collection('Events');

      // Fetch the first event (Modify this logic based on how you want to fetch data)
      QuerySnapshot querySnapshot = await db.limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          eventData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true; // No events found
        });
      }
    } catch (e) {
      print("Error fetching event data: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

 final Map<String, dynamic> eventData; // Event data passed from Firebase
  
  @override
  Widget build(BuildContext context) {

     if (isLoading) {
      return const CircularProgressIndicator(); // Show loading spinner
    }

    if (hasError || eventData == null) {
      return const Center(child: Text("No event found.")); // Handle errors
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: const Center(
                child: Text(
                  'Regular',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Art Festival Ticket',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget(
                  'Organizer', 'The Art Gallary', 'Date', '28-08-2022'),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                ),
                child: ticketDetailsWidget(
                    'Venue', 'Johannesburg', 'Host', 'Tamilika'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
          child: Container(
            width: 250.0,
            height: 60.0,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://www.thechecker.net/hubfs/images/barcode.png'),
                    fit: BoxFit.cover)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0, left: 75.0, right: 75.0),
          child: Text(
            '0000 +9230 2884 5163',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
*/
*/