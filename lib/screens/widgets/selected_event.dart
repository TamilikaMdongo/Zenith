import 'package:flutter/material.dart';
import 'package:prototype/screens/purchase.dart';

class SelectedEvent extends StatelessWidget {
  const SelectedEvent(
      {super.key,
      required this.eventImage,
      required this.eventTitle,
      required this.description,
      required this.host,
      required this.location,
      required this.date,
      required this.price});

  final String eventImage;
  final String eventTitle;
  final String description;
  final String host;
  final String location;
  final String date;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(eventImage), fit: BoxFit.cover)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                eventTitle,
                style: TextStyle(fontSize: 25.0, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(description),
            ),

            // icons and text for event details

            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                Text(host)
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.black,
                ),
                Text(location)
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                Text(date)
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: Colors.black,
                ),
                Text(price)
              ],
            ),

            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Purchase()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                child: const Text(
                  'Buy Tickets',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ],
    );
  }
}
