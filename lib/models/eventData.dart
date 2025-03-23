import 'package:cloud_firestore/cloud_firestore.dart';

class eventData {
  final db = FirebaseFirestore.instance;
  Future<void> storeEventData(
      String eventName,
      String venue,
      String dateAndTime,
      String tickets,
      String price,
      String description) async {
    final data = <String, dynamic>{
      'title': eventName,
      'location': venue,
      'date': dateAndTime,
      'numberOfTickets': tickets,
      'ticketPrice': price,
      'description': description
    };

    await db.collection('Event').add(data);
  }
}
