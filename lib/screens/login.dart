import 'package:app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:app/models/auth.dart';
import 'package:app/screens/bottom_navbar.dart';


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
    final String password = _passwordController.text;
    final user = await _authService.signinWithEmailAndPassword(email, password);
    // ignore: unnecessary_null_comparison
    if (user != null) {
      print('welcome back');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    }
    else{
      print('login failed');
    }
  }
Color customColor = Color(0xFFF8F8FF);


  var _obscure;

  @override 
  void initState (){
    super.initState();
    _obscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,shadowColor: Colors.white),
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
              margin: EdgeInsets.only(right: 15),
              
              width: 300.0,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: customColor,
                    prefixIcon: Icon(Icons.email, color: Colors.black,),
                    hintText: 'Email',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 15),
             
              width: 300.0,
              child: TextField(
                obscureText: _obscure,
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: customColor,
                    prefixIcon: IconButton(icon: _obscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off), onPressed: (){
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },),
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 150),
              child: GestureDetector(
                onTap: signIn,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    child: Container(
                        height: 30,
                        width: 100,
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
                decoration: BoxDecoration(color: Colors.black),
                child: const Center(child: Text('Google', style: TextStyle(color: Colors.white),)),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Dont have an account?'),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                  },
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
                              'Register',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
