import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FinishPage extends StatelessWidget {
  const FinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5, // Set your desired opacity value
              child: Image.asset(
                'assets/images/abh.png', // Replace with your image path
                width: 200.0, // Set your desired width
                height: 200.0, // Set your desired height
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "Thank You For Your Feedback",
              style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Review has been submitted successfully',
              style: TextStyle(color: Colors.blue.shade800, fontSize: 16.0),
            ),
            Opacity(
              opacity: 0.5, // Set your desired opacity value
              child: Image.asset(
                'assets/images/tick.png', // Replace with your image path
                width: 200.0, // Set your desired width
                height: 200.0, // Set your desired height
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child:  Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
