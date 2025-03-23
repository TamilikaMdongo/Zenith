import 'package:flutter/material.dart';
import 'package:prototype/models/auth.dart';
import 'package:prototype/screens/bottom_navbar.dart';
import 'package:prototype/screens/home.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> signIn() async {
    final String email = _emailController.text;
    final String Password = _passwordController.text;
    final user = _authService.signinWithEmailAndPassword(email, Password);
    if (user != null) {
      print('welcome back');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                color: Colors.blue,
                child: Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 30.0, color: Colors.black),
                )),
            SizedBox(height: 40.0),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 90),
              height: 50.0,
              width: 250.0,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 90),
              height: 50.0,
              width: 250.0,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.visibility_off),
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 150),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BottomNavBar()));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.lightGreen),
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
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(height: 30, child: const Text('Or')),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(color: Colors.blue),
                child: const Center(child: Text('Google')),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Dont have an account?'),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(color: Colors.lightGreen),
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
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
