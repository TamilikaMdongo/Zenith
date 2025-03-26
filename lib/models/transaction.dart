import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final db = FirebaseFirestore.instance;
  Future<void>saveTransactionData(Int amount, String userId, String paymentMethod, String ticketID, String eventID) async{
    final transactionData = <String, dynamic>{
      'amount':amount,
      'userId':userId,
      'paymentMethod': paymentMethod,
      'ticketId':ticketID,
      'eventId':eventID
    };
    try{
      await db.collection('Transactions').add(transactionData);
    }
    catch(error){
      print(error);
    }
  }
}