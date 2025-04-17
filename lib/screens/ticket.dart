import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      appBar: AppBar(title: const Text('My Ticket'),forceMaterialTransparency: true,),
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
         
         // String ticketId = ticketDoc.id;
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
              height: 500,
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
                    padding: const EdgeInsets.only(left:50.0,),
                    child: QrImageView(data: ticketNumber, size: 240,),
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

