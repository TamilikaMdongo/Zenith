import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/models/eventData.dart';
//import 'package:app/screens/ticket.dart';

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
Color customColor = Color(0xFFF8F8FF);
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
  // Handle the case when user is not logged in
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Please log in to create an event.'),
  ));
  return;
}
      String userId = user.uid;

    final eventName = _eventNameController.text;
    final venue = _venueController.text;
    final dateAndTime = _dateAndTimeController.text;
    final tickets = _ticketsController.text;
    final price = _priceController.text;
    final description = _descriptionController.text;
    
    CollectionReference docRef = await FirebaseFirestore.instance.collection('Event');
      String eventID = docRef.doc().id;
    final data ={
      'title': eventName,
      'location': venue,
      'date': dateAndTime,
      'numberOfTickets': tickets,
      'ticketPrice': price,
      'userId':userId,
      'description': description,
      'eventImage': _base64String,
      'eventId':eventID
    };
  
    await docRef.doc(eventID).set(data);
   
    await createTicket(eventID);
  }

  List<String> docIDs = [];
  //bool _isLoading = true;

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
          title: const Text('Create event'),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(child: Icon(Icons.arrow_back_ios_new, color: Colors.white,), backgroundColor: Colors.black,),
          ),
        ),
        drawer: Drawer(),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(children: [
              
              Row(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Container(
                      width: 250.0,
                      child: TextFormField( 
                        style: TextStyle(),
                        controller: _eventNameController, 
                        decoration: InputDecoration(hintText: 'Enter event name ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: customColor,  ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(left:10.0, top: 13.0),
                          child: Text('Description', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right:70.0),
                child: Container(
                  width: 250.0,
                  child: TextFormField(
                    controller: _venueController,
                    decoration: InputDecoration(hintText: 'Enter the Venue', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: customColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
               Padding(
                    padding: const EdgeInsets.only(right: 70.0),
                    child: Container(
                      width: 250.0,
                      child: TextFormField( 
                        style: TextStyle(),
                         controller: _descriptionController,
                        decoration: InputDecoration(hintText: 'Description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: customColor,  ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:50.0),
                    child: Container(
                      width: 150.0,
                      child: TextFormField(
                        controller: _dateAndTimeController,
                        decoration:
                            InputDecoration(hintText: 'Enter the date ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: customColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: Container(
                      width: 150.0,
                      child: TextFormField(
                        controller: _dateAndTimeController,
                        decoration:
                            InputDecoration(hintText: 'Enter the time ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: customColor),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
             Padding(
                padding: const EdgeInsets.only(right:70.0),
                child: Container(
                  width: 250.0,
                  child: TextFormField(
                    controller: _ticketsController,
                    decoration: InputDecoration(hintText: 'Number of tickects', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: customColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right:70.0),
                child: Container(
                  width: 250.0,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(hintText: 'Ticket Price', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: customColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
            
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 200),
                child: const Text('Upload file'),
              ),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 200)
                  : Icon(Icons.camera_alt_outlined),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 150.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  ),
                    onPressed: () {
                      _pickImageFromGallery();
                      print('you are selecting the image ');
                    },
                    child: Text('Upload Image', style: TextStyle(color: Colors.white),)),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 200.0, bottom: 200),
                child: ElevatedButton(
                  style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                    onPressed: () {
                     
                    },
                    child: Text('Create Event', style: TextStyle(color: Colors.white),)),
              ),
            ]),
          ),
        ]));
  }
}
