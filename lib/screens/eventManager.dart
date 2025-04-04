import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class EventManager extends StatefulWidget{
const EventManager({super.key});


  @override
  State<EventManager> createState() => _EventManagerState();
}

class _EventManagerState extends State<EventManager> {

 final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if(controller!=null){
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }}
  }

@override
Widget build(BuildContext context){
  return Scaffold(
    body: Column(
        children: <Widget>[
          SizedBox(height: 100,),
          Text('data'),
          SizedBox(
           height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
    borderRadius: 10,
    borderColor: Colors.red,
    borderLength: 30,
    borderWidth: 10,
    cutOutSize: 250,
  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
  );
}


void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async{
    

       setState(() {
    result = scanData;
  });
   String scannedTicketNumber = result!.code ?? '';
    
    print(scannedTicketNumber);
    // Check if the ticket exists in Firestore
    if(scannedTicketNumber.isNotEmpty){
      
    var ticketDoc = await FirebaseFirestore.instance
        .collection('Tickets')
        .where('ticketNumber', isEqualTo: scannedTicketNumber)
        .get();
    
    if (ticketDoc.docs.isEmpty) {
       
      _showDialog('Invalid Ticket', 'This ticket does not exist.');
      return;
    }

var ticketQuerySnapshot = ticketDoc.docs.first;
    Map<String, dynamic> ticketData = ticketQuerySnapshot.data();

    if (ticketData['status'] == 'Active') {
      // Ticket is already used
      _showDialog('Ticket Already Used', 'This ticket has already been scanned.');
      return;
    }

    // Mark the ticket as used
    await FirebaseFirestore.instance
        .collection('Tickets')
        .doc(ticketQuerySnapshot.id)
        .update({'status': true});

    // Success message
    _showDialog('Valid Ticket', 'Welcome');
   //  _showDialog('Valid Ticket', 'Welcome, ${ticketData['eventname']}!');
  }});
    
  }

  void _showDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>EventManager())),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

}