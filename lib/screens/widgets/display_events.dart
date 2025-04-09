import 'package:flutter/material.dart';
//import 'package:app/screens/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayEvents extends StatefulWidget {
  final dynamic image;
  final String title;
  //final String description;
  final String venue;
  final String date;
  final String price;

  const DisplayEvents(
      {super.key,
      required this.image,
      required this.title,
     // required this.description,
      required this.venue,
      required this.date, required this.price});

  @override
  State<DisplayEvents> createState() => _DisplayEventsState();
}

class _DisplayEventsState extends State<DisplayEvents> {
  Color myColor = Color(0xFF222222);
  Future<void> saveEventData(String image, String title, String description,
      String venue, String date, String price) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('Event');
    String docId = ref.doc().id;
    image = image;
    venue = venue;
    title = title;
    description = description;
    date = date;
    price = price;
    final data = {
      'image': image,
      'title': title,
      'description': description,
      'venue': venue,
      'date': date,
      'ticketPrice':price,
      'eventId':docId
    };
    await ref.doc(docId).set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 30,),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        
          child: Card(
              
              color: myColor,
              child: Container(
                height: 350,
                width: 320,
                child: Column(
                  children: [
                    
                    Image.memory(
                      widget.image,
                      height: 200,
                      width: 350, fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:10, top: 30),
                      child: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 18.0),),
                    ),
                       SizedBox(height: 20.0),     //     Text(description, style: TextStyle(color: Colors.white),),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.white,size: 30,),
                          Text(widget.venue,style: TextStyle(color: Colors.white),),
                      
                          Padding(
                            padding: const EdgeInsets.only(left:60.0),
                            child: Icon(Icons.calendar_month, color: Colors.white,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(widget.date,style: TextStyle(color: Colors.white, fontSize: 18),),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 220.0,top: 10.0 ),
                      child: Text('R ${widget.price}', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                    ),
                    
                  ],
                ),
              )),
        
      ),
      SizedBox(height: 30,)
    ]);
  }
}
