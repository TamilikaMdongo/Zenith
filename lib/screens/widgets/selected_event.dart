import 'package:flutter/material.dart';
import 'package:app/screens/purchase.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

class SelectedEvent extends StatelessWidget {
  const SelectedEvent(
      {super.key,
      required this.eventImage,
      required this.eventTitle,
      required this.description,
      required this.host,
      required this.location,
      required this.date,
      required this.price});

  final String eventImage;
  final String eventTitle;
  final String description;
  final String host;
  final String location;
  final String date;
  final String price;

  @override
  Widget build(BuildContext context) { 
    return Expanded(
      child: SingleChildScrollView(
      child: Column(
        children: [ SizedBox(height: 100,),
          Column(
            children: [
              Stack(
                children: [ Padding( 
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircleAvatar(child: Icon(Icons.arrow_back), radius: 20, backgroundColor: Colors.black,),
                ),
                  ClipRRect( borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 500,
                      width:400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(eventImage), fit: BoxFit.cover)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  eventTitle,
                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(description),
              ),
      
              // icons and text for event details
      
             
      
              ElevatedButton(
                  onPressed: () {
                      final uniqueTransRef = PayWithPayStack().generateUuidV4();

                  PayWithPayStack().now(
                      context: context,
                      secretKey:"sk_live_e8e7f4cb1d2d50d51b5f5ec1dc66cb85ba6bd522",
                      customerEmail: "mdongotamilika45@gmail.com",
                      reference: uniqueTransRef,
                      currency: "ZAR",
                      amount: 10,
                      callbackUrl: "https://google.com",
                      transactionCompleted: (paymentData) {
                          debugPrint(paymentData.toString());
                      },
                      transactionNotCompleted: (reason) {
                        debugPrint("==> Transaction failed reason $reason");
                      });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white),
                  child: const Text(
                    'Buy Tickets',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ],
      ),)
    );
  }
}
