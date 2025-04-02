import 'package:flutter/material.dart';
import 'package:app/screens/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayEvents extends StatelessWidget {
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
      ClipRRect(
        borderRadius: BorderRadius.circular(25),
        
          child: Card(
              
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Container(
                height: 300,
                width: 350,
                child: Column(
                  children: [
                    Image.memory(
                      image,
                      height: 150,
                      width: 350, fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20, top: 30),
                      child: Text(title, style: TextStyle(color: Colors.white),),
                    ),
                       SizedBox(height: 20.0),     //     Text(description, style: TextStyle(color: Colors.white),),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.white,),
                          Text(venue,style: TextStyle(color: Colors.white),),
                      
                          Padding(
                            padding: const EdgeInsets.only(left:45.0),
                            child: Icon(Icons.calendar_month, color: Colors.white,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text('2025/03/01',style: TextStyle(color: Colors.white),),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 250.0,top: 10.0 ),
                      child: Text('R ${price}', style: TextStyle(color: Colors.white, fontSize: 18.0),),
                    )
                  ],
                ),
              )),
        
      ),
    ]);
  }
}
