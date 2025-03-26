import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:paystack_for_flutter/paystack_for_flutter.dart';

class Purchase extends StatefulWidget {
  
  const Purchase({super.key});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  @override
  Widget build(BuildContext context) {
    Color customColor = Color(0xFFF8F8FF);
    return Scaffold(
      appBar: AppBar(leading: CircleAvatar(radius: 30, backgroundColor: customColor, child: Icon(Icons.arrow_back),), backgroundColor: Colors.white,),
      body: ListView(
        children:[ Column(
          children:[
            SizedBox(height: 100.0,),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Container(
                width: 300,
                child: TextField(
                
                  decoration: InputDecoration( border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), hintText: 'Full Name', filled: true,fillColor: customColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Container(
                width: 300,
                child: TextField(
                
                  decoration: InputDecoration( border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), hintText: 'Full Name', filled: true,fillColor: customColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Container(
                width: 300,
                child: TextField(
                
                  decoration: InputDecoration( border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), hintText: 'Full Name', filled: true,fillColor: customColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            const Text('Payment method', style: TextStyle(fontSize: 20,),),
            // payment options
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    color: customColor,
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.creditCard),
                        const Text('card')
                      ],
                    ),
              
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    color: customColor,
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.googlePay),
                        const Text('Google Pay')
                      ],
                    ),
              
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    color: customColor,
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.bank),
                        const Text('Bank')
                      ],
                    ),
              
                  )
                ],
              ),
            ),
        
            // card input
            SizedBox(height: 40),
            const Text('Card Information', style: TextStyle(fontSize: 20),),
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'card number'),
              ),
            ),
            // cvc and date 
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:55.0, top: 20),
                  child: Container(
                    height: 50,
                    width: 150,
                    color: customColor,
                    child: TextField(
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Expiration date'),
                    ),
                  ),
                ),
                   Padding(
                  padding: const EdgeInsets.only(left:30.0, top: 20),
                  child: Container(
                    height: 50,
                    width: 150,
                    color: customColor,
                    child: TextField(
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Expiration date'),
                    ),
                  ),
                ),
              ],
            ),
            // pay button
            Padding(
              padding: const EdgeInsets.only(left: 220, top: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GestureDetector(
                  // webview code
                  onTap: (){
                     final uniqueTransRef = PayWithPayStack().generateUuidV4();

                  PayWithPayStack().now(
                      context: context,
                      secretKey:"sk_live_e8e7f4cb1d2d50d51b5f5ec1dc66cb85ba6bd522",
                      customerEmail: "mdongotamilika45@gmail.com",
                      reference: uniqueTransRef,
                      currency: "ZAR",
                      amount: 20000,
                      callbackUrl: "https://google.com",
                      transactionCompleted: (paymentData) {
                          debugPrint(paymentData.toString());
                      },
                      transactionNotCompleted: (reason) {
                        debugPrint("==> Transaction failed reason $reason");
                      });
                  },
                  child: Container(
                    height: 50.0,
                    width: 130.0,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, top: 13),
                      child: const Text('Pay', style: TextStyle(fontSize:15 ,color: Colors.white),),
                    ),
                  ),
                ),
              ),
            )
        
          ]
      
        ),
        ]
      )

    );
  }
}
