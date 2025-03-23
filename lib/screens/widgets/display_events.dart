import 'package:flutter/material.dart';
import 'package:prototype/screens/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayEvents extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String venue;
  final String date;

  const DisplayEvents(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.venue,
      required this.date});

  Future<void> saveEventData(String image, String title, String description,
      String venue, String date) async {
    final db = await FirebaseFirestore.instance;
    image = image;
    venue = venue;
    title = title;
    description = description;
    date = date;
    final data = {
      'image': image,
      'title': title,
      'description': description,
      'venue': venue,
      'date': date,
    };
    db.collection('Events').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Event()));
          },
          child: Container(
              height: 300,
              width: 320,
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  Image.network(
                    image,
                    height: 100,
                    width: 100,
                  ),
                  Row(
                    children: [],
                  ),
                ],
              )),
        ),
      ),
    ]);
  }
}
