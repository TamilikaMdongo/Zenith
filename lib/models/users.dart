import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final db = FirebaseFirestore.instance;
  Future<void> saveUserData(String firstName, String lastName, String email,
      String password, String phoneNumber) async {
    print('Attempting to print user data');
    final user = <String, dynamic>{
      lastName: lastName,
      email: email,
      firstName: firstName,
      password: password,
    };

    try {
      await db.collection('Users').add(user);
      print('User Data saved successfully');
    } catch (error) {
      print(error);
    }
  }

  Future<Users?> fetchUserData() async {
    final userData = await db.collection('Users').get();
    print(userData);
  }
}
