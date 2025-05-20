import 'dart:convert';
import 'dart:typed_data';

import 'package:app/screens/bottom_navbar.dart';
import 'package:app/screens/create_event.dart';
import 'package:app/screens/discover.dart';
import 'package:app/screens/login.dart';
import 'package:app/screens/my_events.dart';
import 'package:app/screens/ticket.dart';
import 'package:app/screens/widgets/selected_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/screens/widgets/display_events.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = FirebaseFirestore.instance;
  Uint8List _decodeBase64(String base64String) {
    return base64Decode(base64String);
  }
  String? firstName;
  
  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _allEvents = [];
  List<QueryDocumentSnapshot> _searchResults = [];
  List<String> _searchSuggestions = [];
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    // Fetch all events initially to have local data for suggestions
    _fetchAllEvents();
    
    // Add listener for search input changes
    _searchController.addListener(() {
      // Debug print to verify listener is working
      print('Search text changed: ${_searchController.text}');
      if (_searchController.text.isNotEmpty) {
        _getSearchSuggestions(_searchController.text);
      } else {
        setState(() {
          _searchSuggestions = [];
          _searchResults = [];
        });
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch all events for local searching
  Future<void> _fetchAllEvents() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Print statement for debugging
      print('Fetching all events for suggestions');
      QuerySnapshot eventSnapshot = await db.collection('Event').get();
      setState(() {
        _allEvents = eventSnapshot.docs;
        print('Fetched ${_allEvents.length} events for suggestions');
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Generate search suggestions based on user input
  void _getSearchSuggestions(String query) {
    print('Getting suggestions for: $query');
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
      });
      return;
    }
    
    // Create suggestions from event titles
    List<String> suggestions = [];
    for (var event in _allEvents) {
      Map<String, dynamic> data = event.data() as Map<String, dynamic>;
      String title = data['title']?.toString() ?? '';
      
      if (title.toLowerCase().contains(query.toLowerCase()) && 
          !suggestions.contains(title) &&
          suggestions.length < 5) {  // Limit to 5 suggestions
        suggestions.add(title);
      }
    }
    
    print('Found ${suggestions.length} suggestions');
    setState(() {
      _searchSuggestions = suggestions;
    });
  }

  // Search events with Firestore query
  Future<void> _searchEvents(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
    });
    
    try {
      // Search for events where title contains the query (case insensitive not directly supported)
      QuerySnapshot searchSnapshot = await db
        .collection('Event')
        .get();
        
      // Filter results manually for case-insensitive search
      List<QueryDocumentSnapshot> filteredResults = searchSnapshot.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String title = data['title']?.toString() ?? '';
        return title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      setState(() {
        _searchResults = filteredResults;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch the current user's first name from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      print("Logged in UID: ${user.uid}");
      QuerySnapshot userSnapshot = await db
          .collection('Users')
          .where('userId', isEqualTo: user.uid)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          firstName = userData['firstName'];  
        });
      }
    }
  }
  
  // Toggle search mode
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchSuggestions = [];
        _searchResults = [];
      }
    });
  }
  
  // Navigate to event details
  void _navigateToEventDetails(String eventId, Map<String, dynamic> eventData) {
    String eventTitle = eventData['title'] ?? "No Title";
    String eventLocation = eventData['location'] ?? "No Location";
    String eventImagebase64 = eventData['eventImage'] ?? "";
    String price = eventData['ticketPrice'] ?? "0";
    String eventDate = eventData['date'] ?? "";
    Uint8List imagebytes = _decodeBase64(eventImagebase64);
    
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => SelectedEvent(
          eventImage: imagebytes, 
          eventTitle: eventTitle, 
          eventId: eventId, 
          price: price, 
          venue: eventLocation, 
          date: eventDate,
        )
      )
    );
  }
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        shadowColor: Colors.white,
        bottomOpacity: 0,
        forceMaterialTransparency: true,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _searchEvents(_searchController.text);
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onChanged: (value) {  // Added explicit onChanged handler
                  if (value.isNotEmpty) {
                    _getSearchSuggestions(value);
                  } else {
                    setState(() {
                      _searchSuggestions = [];
                    });
                  }
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _searchEvents(value);
                  }
                },
              )
            : null,
        leading: _isSearching
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _toggleSearch,
              )
            : null,
        actions: [
          // Search icon
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          // Notifications icon
          if (!_isSearching)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.notifications),
            ),
        ],
      ),
      
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(child: const Text('Zenith', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)),
            ListTile(
              title: Text('Home'),
              leading: Icon(CupertinoIcons.home),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
              },
            ),
            ListTile(
              title: Text('Search'),
              leading: Icon(CupertinoIcons.search),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Discover()));
              },
            ),
            ListTile(
              title: Text('Create event'),
              leading: Icon(CupertinoIcons.create),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEvent()));
              },
            ),
            ListTile(
              title: Text('My Events'),
              leading: Icon(CupertinoIcons.calendar),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyEvents()));
              },
            ),
            ListTile(
              title: Text('Tickets'),
              leading: Icon(CupertinoIcons.tickets),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyTicketView()));
              },
            ),
            SizedBox(height: 220.0),
            ListTile(
              title: Text('Logout'),
              leading: Icon(CupertinoIcons.square_arrow_right),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
      
      body: _isSearching 
          ? _buildSearchUI()
          : _buildHomeUI(),
    );
  }
  
  Widget _buildSearchUI() {
    // Debug prints to verify UI building
    print('Building search UI');
    print('Search suggestions: ${_searchSuggestions.length}');
    print('Search results: ${_searchResults.length}');
    
    return Column(
      children: [
        // Show suggestions if there are any and we're not showing results yet
        if (_searchSuggestions.isNotEmpty && _searchResults.isEmpty && !_isLoading)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Suggestions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.search),
                          title: Text(_searchSuggestions[index]),
                          onTap: () {
                            _searchController.text = _searchSuggestions[index];
                            _searchEvents(_searchSuggestions[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        // Show loading indicator
        if (_isLoading)
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          
        // Show search results
        if (_searchResults.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Found ${_searchResults.length} events',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var eventData = _searchResults[index].data() as Map<String, dynamic>;
                      String eventId = _searchResults[index].id;
                      String eventTitle = eventData['title'] ?? "No Title";
                      String eventLocation = eventData['location'] ?? "No Location";
                      String eventDate = eventData['date'] ?? "";
                      String eventImagebase64 = eventData['eventImage'] ?? "";
                      
                      // Prepare small thumbnail
                      Widget thumbnail;
                      if (eventImagebase64.isNotEmpty) {
                        try {
                          Uint8List imagebytes = _decodeBase64(eventImagebase64);
                          thumbnail = ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              imagebytes,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          );
                        } catch (e) {
                          thumbnail = Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported),
                          );
                        }
                      } else {
                        thumbnail = Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(Icons.event),
                        );
                      }
                      
                      return ListTile(
                        leading: thumbnail,
                        title: Text(eventTitle),
                        subtitle: Text('$eventLocation • $eventDate'),
                        onTap: () => _navigateToEventDetails(eventId, eventData),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
        // Show "no results" message
        if (_searchController.text.isNotEmpty && _searchResults.isEmpty && !_isLoading && _searchSuggestions.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No events found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try different keywords',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildHomeUI() {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('Event').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("No event data found"));
        }
        
        var eventData = snapshot.data!.docs;
        
        return CustomScrollView(
          slivers: [
            // Welcome message in a SliverToBoxAdapter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Welcome Back, ',
                      style: TextStyle(fontSize: 18),
                    ),
                    firstName != null
                        ? Text(
                            firstName!,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            'username loading...',
                            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                  ],
                ),
              ),
            ),
            
            // Event list in a SliverList
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var events = eventData[index].data() as Map<String, dynamic>;
                  String eventTitle = events['title'] ?? "No Title";
                  String eventLocation = events['location'] ?? "No Location";
                  String eventImagebase64 = events['eventImage'] ?? "";
                  String price = events['ticketPrice'] ?? "0";
                  String eventDate = events['date'] ?? "";
                  Uint8List imagebytes = _decodeBase64(eventImagebase64);
                  String eventId = eventData[index].id;
                  
                  if (eventId.isEmpty || eventId == null) {
                    return Center(child: Text('Event ID is missing.'));
                  } else {
                    return GestureDetector(
                      onTap: () {
                        print(eventId);
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => SelectedEvent(
                              eventImage: imagebytes, 
                              eventTitle: eventTitle, 
                              eventId: eventId, 
                              price: price, 
                              venue: eventLocation, 
                              date: eventDate,
                            )
                          )
                        );
                      },
                      child: DisplayEvents(
                        image: imagebytes,
                        title: eventTitle,
                        venue: eventLocation,
                        date: eventDate,
                        price: price,
                      ),
                    );
                  }
                },
                childCount: eventData.length,
              ),
            ),
          ],
        );
      },
    );
  }
}