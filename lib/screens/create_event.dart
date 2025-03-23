import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prototype/models/eventData.dart';
import 'package:prototype/screens/ticket.dart';

class CreateEvent extends StatefulWidget {
  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _imageurl;
  String? _base64String;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _dateAndTimeController = TextEditingController();
  final TextEditingController _ticketsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final eventData _eventData = eventData();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request camera and storage permissions
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus storageStatus = await Permission.storage.request();

    // Check if permissions are granted
    if (cameraStatus.isGranted && storageStatus.isGranted) {
      print("Permissions granted.");
    } else {
      print("Permissions denied.");
      // You can show a Snackbar or a dialog if permissions are denied.
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageurl = null;
      });
    }

    await _convertToBase64(_imageFile!);
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageurl = null;
      });
    }

    await _convertToBase64(_imageFile!);
  }

  Future<void> _convertToBase64(File image) async {
    List<int> imageBytes = await image.readAsBytes();
    String base64String = base64Encode(imageBytes);

    setState(() {
      _base64String = base64String;
    });

    final eventName = _eventNameController.text;
    final venue = _venueController.text;
    final dateAndTime = _dateAndTimeController.text;
    final tickets = _ticketsController.text;
    final price = _priceController.text;
    final description = _descriptionController.text;

    DocumentReference doc =
        await FirebaseFirestore.instance.collection('Event').add({
      'title': eventName,
      'location': venue,
      'date': dateAndTime,
      'numberOfTickets': tickets,
      'ticketPrice': price,
      'description': description,
      'eventImage': _base64String
    });
    String eventID = doc.id;
    await createTicket(eventID);
  }

  List<String> docIDs = [];
  bool _isLoading = true;

  Future<void> createTicket(String eventID) async {
    final price = _priceController.text;
    final quantity = _ticketsController.text;

    await FirebaseFirestore.instance.collection('Tickets').add({
      'price': price,
      'quantity': quantity,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
      "eventID": eventID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(),
        body: ListView(children: [
          Column(children: [
            SizedBox(height: 20),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(hintText: 'Enter event name '),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: _venueController,
                decoration: InputDecoration(hintText: 'Enter the Venue'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: _dateAndTimeController,
                decoration:
                    InputDecoration(hintText: 'Enter the Date and Time '),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: _ticketsController,
                decoration: InputDecoration(
                    hintText: 'How many tickects do you have for sale'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: _priceController,
                decoration:
                    InputDecoration(hintText: 'How much are those tickets'),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    hintText: 'Enter a description for you event'),
              ),
            ),
            SizedBox(height: 20),
            const Text('Add Media'),
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : Icon(Icons.camera_alt_outlined),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                  print('you are selecting the image poi');
                },
                child: Text('Upload Image')),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyTicketView()));
                },
                child: Text('Create Event')),
          ]),
        ]));
  }
}
