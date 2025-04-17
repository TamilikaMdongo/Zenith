import 'dart:convert';
import 'dart:typed_data';

// ignore: unused_import
import 'package:app/models/transaction.dart';
// ignore: unused_import
import 'package:app/screens/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:app/screens/purchase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:uuid/uuid.dart';



class SelectedEvent extends StatefulWidget {
  
  final dynamic eventImage;
  final String eventTitle;
  final String eventId;
  final String price;
  final String date;
  final String venue;
  const SelectedEvent(
      {super.key,
      required this.eventImage,
      required this.eventTitle,
      required this.eventId, required this.price, required this.date, required this.venue
     });

  
  

  @override
  State<SelectedEvent> createState() => _SelectedEventState();
}

class _SelectedEventState extends State<SelectedEvent> {
   final db = FirebaseFirestore.instance;
  
  // save payment/transaction details
    Uint8List _decodeBase64(String base64String) {
    return base64Decode(base64String);
  }
  String? eventPic;
  
  Future <void> getEventData () async{
    DocumentSnapshot eventInfo = await db.collection('Event').doc('yp1kcvm1DNwG8B7e2akZ').get();
     eventPic = eventInfo.get('eventImage');
  }
  Future <void> saveTransaction () async{
     
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Event').doc('CZHfIPMkiBMDlpZqQf70').get();
      
    // ignore: unused_local_variable
    String docID = doc.id;
    print(doc.id);


    // get amount
   String ? userId = FirebaseAuth.instance.currentUser?.uid;
    String amount = doc.get('ticketPrice');
    db.collection('Transactions').add({
      'amount':amount,
      'userID': userId,
      
    });
    print(amount);
   
    // get eventID
    
    // ignore: unused_element
    String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;  // Return the user ID
  }

    // get userID
    
    // include date
  }

  Future <void> createTicket () async{
    CollectionReference tickets = FirebaseFirestore.instance.collection('Tickets');
    String ? userId = FirebaseAuth.instance.currentUser?.uid;
    // ignore: unused_local_variable
    final bool isActive = false;
    String status = 'Inactive';
    String ticketId = tickets.doc().id;
    var uuid = Uuid();
String ticketNumber = uuid.v4(); // Generates a random UUID
    final data ={
      'eventId':widget.eventId,
      'ticketId':ticketId,
      'price': widget.price,
      'userID':userId,
      'ticketNumber':ticketNumber,
      'purchaseDate':FieldValue.serverTimestamp(),
      'eventName':widget.eventTitle,
      'eventDate':widget.date,
      'venue':widget.venue,
      'payment':'',
      'status':status

    };
   tickets.add(data);
  }

  @override
  Widget build(BuildContext context){

    

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, forceMaterialTransparency: true,),
      body: StreamBuilder <DocumentSnapshot>(stream: db.collection('Event').doc(widget.eventId).snapshots(),
      
       builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
         if (!snapshot.hasData || snapshot.data == null) {
        return Center(child: Text("No event data found"));
      }
      
        
        var eventData = snapshot.data!; 
        String eventImage = eventData ['eventImage'];
        String eventDescription = eventData['description'];
        String eventPrice = eventData['ticketPrice'];
        String eventTitle = eventData['title'];
        int price = int.parse(eventPrice);
         Uint8List imageBytes = _decodeBase64(eventImage);
       
        return ListView(
          children:[ Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 600,
                  width:350,
                  child:Image.memory(imageBytes, fit: BoxFit.cover,) ,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(eventTitle, style: TextStyle(fontSize: 18),),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(eventDescription, style: TextStyle(fontSize: 18),),
               ),
                ElevatedButton(
                      onPressed: () {
                    //    Navigator.push(context, MaterialPageRoute(builder: (context) => MyTicketView()));
                     
                 
                        
                        
                      
                      final uniqueTransRef = PayWithPayStack().generateUuidV4();
                    final secretKey = dotenv.env['secretKey'] ?? '';
                      PayWithPayStack().now(
                          context: context,
                          secretKey:secretKey,
                          // get the user email from the database
                          customerEmail: "mdongotamilika45@gmail.com",
                          reference: uniqueTransRef,
                          currency: "ZAR",
                          // get the amount from the database
                          amount: price.toDouble(),
                          callbackUrl: "https://google.com",
                          transactionCompleted: (paymentData) {
                              createTicket();
                              debugPrint(paymentData.toString());
                               Navigator.push(context, MaterialPageRoute(builder: (context)
                              =>MyTicketView()));
                              
                             
                          },
                          transactionNotCompleted: (reason) {
                            debugPrint("==> Transaction failed reason $reason");
                            Navigator.pop(context);
                          });

                          
                         
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white),
                      child: const Text(
                        'Buy Tickets',
                        style: TextStyle(color: Colors.white),
                      ))
              
            ],
          ),]
        );}
      
       
       ),
    );
  }
}

