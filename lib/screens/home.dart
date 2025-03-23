import 'package:flutter/material.dart';
import 'package:prototype/screens/event.dart';
import 'package:prototype/screens/login.dart';
import 'package:prototype/screens/register.dart';
import 'package:prototype/screens/widgets/display_events.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void doNothing() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: 30,
              width: 200.0,
              decoration: const BoxDecoration(color: Colors.white),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.only(right: 50)),
              )),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 10),
            child: CircleAvatar(
              radius: 20,
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
            ),
          )
        ],
      ),
      // sidebar widget
      drawer: Drawer(
        backgroundColor: Colors.blue,
        // creates a list of all the items in the sidebar/drawer
        child: ListView(
          padding: EdgeInsets.zero,
          // the children of the listview
          children: <Widget>[
            DrawerHeader(child: Text('data')),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.white),
              title: const Text(
                'My Events',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              title: const Text(
                'Discover',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
          ],
        ),
      ),
      body: ListView(children: [
        SizedBox(
          height: 50.0,
        ),
        Column(children: <Widget>[
          // category buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('All Categories'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('Concert'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('Entertainment'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('Business'),
                ),
                ElevatedButton(
                  onPressed: doNothing,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  child: Text('All Categories'),
                )
              ],
            ),
          ),
          const SizedBox(height: 30.0),

          DisplayEvents(
              image:
                  'https://media.about.nike.com/img/cf68f541-fc92-4373-91cb-086ae0fe2f88/002-nike-logos-swoosh-white.jpg?m=eyJlZGl0cyI6eyJqcGVnIjp7InF1YWxpdHkiOjEwMH0sIndlYnAiOnsicXVhbGl0eSI6MTAwfSwiZXh0cmFjdCI6eyJsZWZ0IjowLCJ0b3AiOjAsIndpZHRoIjo1MDAwLCJoZWlnaHQiOjI4MTN9LCJyZXNpemUiOnsid2lkdGgiOjY0MH19fQ%3D%3D&s=cc94b2cc61c9c80ba68eb593e20d3bd8345d1ce8817f826c1c3126aae59e7933',
              title: 'Art Show',
              description:
                  'For all our Art fans please come by downtown for our exclusive art showcase',
              venue: 'Joburg Downtown',
              date: '5 February'),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Event()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                  height: 200,
                  width: 320,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1737357126863-c6e6b1fff33d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D'),
                              radius: 30,
                            ),
                          ),
                          Text('Google Developers',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'we are pleased to announce that we are the ones who will be hosting the keynote this year',
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: Text('Silicon Valey  CA',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: Text('15 April 2025',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )),
            ),
          ),
          SizedBox(height: 25),
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
                height: 200,
                width: 320,
                color: Colors.blue,
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1736772424997-d060a145965d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw0NHx8fGVufDB8fHx8fA%3D%3D'),
                            radius: 30,
                          ),
                        ),
                        Text('Google Developers',
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'we are pleased to announce that we are the ones who will be hosting the keynote this year',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text('Silicon Valey  CA',
                          style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text('15 April 2025',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )),
          ),

          SizedBox(height: 25),
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
                height: 200,
                width: 320,
                color: Colors.greenAccent,
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1737562963380-3a7e45c0bf31?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyNnx8fGVufDB8fHx8fA%3D%3D'),
                            radius: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Google Developers',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'we are pleased to announce that we are the ones who will be hosting the keynote this year',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text('Silicon Valey  CA',
                          style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Text('15 April 2025',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )),
          ),
          SizedBox(height: 20.0)
        ]),
      ]),
    );
  }
}
