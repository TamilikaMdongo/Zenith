import 'package:flutter/cupertino.dart';
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
  Color cardColor =Color(0xFFF9F9F9);
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
Color cardCol = Color(0xFFF8F8FF);
  @override
  Widget build(BuildContext context) {
  return Column(
    children:[
      ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Container(
          height: 400,
          width: 330,
          
          decoration: BoxDecoration(
            color: cardCol,
            boxShadow:[ BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
        spreadRadius: 30,
        blurRadius: 10,
        offset: Offset(1, 3),
            )]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ClipRRect(borderRadius: BorderRadius.circular(30),child: Image.memory(widget.image, height: 160, width: 300, fit: BoxFit.cover)),
              ),
              Flexible(child: Padding (padding: EdgeInsets.only(top: 25.0), child: Text(widget.title, style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold )))),

              
              Padding(padding: EdgeInsets.only(right: 50, top: 20.0), child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(CupertinoIcons.calendar),
                  Padding(
                    padding: const EdgeInsets.only(right:70.0),
                    child: Text(widget.date, style: TextStyle(fontSize: 18.0),),
                  ),
                ],
              )),
              //
               Row(
                
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(left:25.0, top: 10),
                    child: Icon(CupertinoIcons.location_solid),
                  ),
                    SizedBox(width: 40),
                     Text(widget.venue, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),),
                  
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 150.0, top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                  height: 35,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 20.0

                      )
                    ]
                  ),
                 
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Text(widget.price),
                  ),
                  
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      SizedBox(height: 30.0),
    ]
  );  
  }
}
/*
return Column(children: [
      SizedBox(height: 30,),
      ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Card(
                
                color: Colors.white,
                child: Container(
                  height:400,
                  width: 320,
                  child: Column(
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(
                            widget.image,
                            height: 200,
                            width: 250, fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:10, top: 30),
                        child: Text(widget.title, style: TextStyle(color: Colors.black, fontSize: 18.0),),
                      ),
                         SizedBox(height: 20.0),     //     Text(description, style: TextStyle(color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.black,size: 30,),
                            Text(widget.venue,style: TextStyle(color: Colors.black),),
                        
                            Padding(
                              padding: const EdgeInsets.only(left:60.0),
                              child: Icon(Icons.calendar_month, color: Colors.black,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(widget.date,style: TextStyle(color: Colors.black, fontSize: 18),),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 220.0,top: 10.0 ),
                        child: Text('R ${widget.price}', style: TextStyle(color: Colors.black, fontSize: 18.0),),
                      ),
                      
                    ],
                  ),
                )),
          ),
        
      ),
      SizedBox(height: 30,)
    ]);
*/