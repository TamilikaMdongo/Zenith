import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/models/auth.dart';
import 'package:app/models/users.dart';
//import 'package:app/screens/bottom_navbar.dart';
import 'package:app/screens/login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final AuthService _authService = AuthService();
  final Users _userData = Users();

  Future<void> signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final user = await _authService.signupWithEmailAndPassword(email, password);

    if (user != null) {
      print('successfully registered');
      await saveUser();

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      print('error signing up or saving user');
    }
  }

  Future<void> saveUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneNumberController.text;
    await _userData.saveUserData(
         firstName,
         lastName, 
         email, 
         password,
         phoneNumber,currentUser!.uid);
  }
Color customColor = Color(0xFFF8F8FF);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, shadowColor: Colors.white,),
      body: ListView(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover))),
            ),
            SizedBox(height: 20),
            Title(
                color: Colors.black,
                child: Text(
                  'Create a new account ',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                )),
            SizedBox(height: 40.0),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20),
             
              width: 300.0,
              child: TextField(
                
                controller: _firstNameController,
                decoration: InputDecoration( border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none
                ), filled: true,
                fillColor: customColor,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.person, color: Colors.black,),
                    hintText: 'First Name',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20),
            
              width: 300.0,
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none
                ), filled: true,
                fillColor: customColor,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.person, color: Colors.black,),
                    hintText: 'Last Name',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20),
              
              width: 300.0,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none
                ), filled: true,
                fillColor: customColor,
                    prefixIcon: Icon(Icons.email,color: Colors.black,),
                    hintText: 'Email',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20),
             
              width: 300.0,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none
                  
                ), filled: true,
                fillColor: customColor,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.visibility_off, color: Colors.black,),
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 160),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(color: Colors.black),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Already have an account?'),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 28.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: 30,
                          width: 90,
                          decoration: BoxDecoration(color: Colors.black),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ]),
    );
  }
}
