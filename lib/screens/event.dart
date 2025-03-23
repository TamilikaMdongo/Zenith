import 'package:flutter/material.dart';
import 'package:prototype/screens/widgets/selected_event.dart';

class Event extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SelectedEvent(
          eventImage:
              'https://images.unsplash.com/photo-1736842666465-5234629bff2b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDExfE04alZiTGJUUndzfHxlbnwwfHx8fHw%3D',
          eventTitle: 'Annual Art Conference',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
          host: 'Steve Owens',
          location: 'New York City',
          date: '19 April 2025',
          price: '\250')
    ]));
  }
}

/* 
 Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1550191600-4e32ab70e8c3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YXJ0JTIwc2hvd3xlbnwwfHwwfHx8MA%3D%3D'))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: const Text(
              'Annual Art Show 2025',
              style: TextStyle(fontSize: 25.0, color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae convallis arcu. Maecenas varius diam id lectus hendrerit, sed sodales nisi viverra. Cras at felis id risus convallis suscipit. Integer volutpat, augue vitae tincidunt finibus, ligula sem tincidunt libero, non tristique ipsum libero vitae magna. Vivamus nec libero a tortor sollicitudin feugiat.'),
          ),

          // icons and text for event details

          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.blue,
              ),
              const Text('Art Festival')
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.blue,
              ),
              const Text('79 Malbrough Drive Sandton')
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
              const Text('79 Malbrough Drive Sandton')
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                color: Colors.blue,
              ),
              const Text('250')
            ],
          ),

          ElevatedButton(
              onPressed: null,
              child: const Text(
                'Buy Tickets',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
*/