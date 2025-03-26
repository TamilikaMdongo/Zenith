import 'package:app/screens/widgets/selected_event.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/event.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/register.dart';
import 'package:app/screens/widgets/display_events.dart';

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

          GestureDetector( onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedEvent(eventImage: 'https://images.unsplash.com/photo-1742199009963-c028d0c5a603?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', eventTitle: 'test event', description: 'an event hosted by me to test the functionality of the darn app', host: 'Tamilika mdogngo', location: 'rossettenville', date: '20 jan', price: '20')));
          },
            child: DisplayEvents(
                image:
                    'https://images.unsplash.com/photo-1742199009963-c028d0c5a603?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                title: 'Art Show',
                description:
                    'For all our Art fans please come by downtown for our exclusive art showcase',
                venue: 'Joburg Downtown',
                date: '5 February'),
          ),
          DisplayEvents(
              image:
                  'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWVyY2VkZXN8ZW58MHx8MHx8fDA%3D',
              title: 'Art Show',
              description:
                  'For all our Art fans please come by downtown for our exclusive art showcase',
              venue: 'Joburg Downtown',
              date: '5 February'),
          DisplayEvents(
              image:
                  'https://images.unsplash.com/photo-1742505709449-fa7df02e0164?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw4fHx8ZW58MHx8fHx8',
              title: 'Art Show',
              description:
                  'For all our Art fans please come by downtown for our exclusive art showcase',
              venue: 'Joburg Downtown',
              date: '5 February'),
        ]),
      ]),
    );
  }
}
