import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:feedback_abhyaz/Finish.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'colors.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



TextEditingController feedbackController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController yournameController = TextEditingController();
TextEditingController emailidController = TextEditingController();
TextEditingController deptController = TextEditingController();
TextEditingController durationController = TextEditingController();


class UI extends StatefulWidget {
  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  Future<String> uploadImageToFirebase() async {
    if (_selectedImage != null) {
      try {
        Reference storageReference = FirebaseStorage.instance.ref().child('feedback_images/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = storageReference.putFile(_selectedImage!);
        await uploadTask.whenComplete(() => null);
        String imageURL = await storageReference.getDownloadURL();
        return imageURL;
      } catch (error) {
        print("Error uploading image: $error");
        return "";
      }
    } else {
      return "";
    }
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  List<bool> isTypeSelected = [false, false, false, false, false];
  User? userid = FirebaseAuth.instance.currentUser;
  double userRating1 = 0.0;
  double userRating2 = 0.0;
  double userRating3 = 0.0;
  double userRating4 = 0.0;
  double userRating5 = 0.0;
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    // TextEditingController feedbackController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          "Feedback",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 50),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              title: const Text("Signout"),
              trailing: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
      // Background Image
      Positioned.fill(
      child: Opacity(
        opacity: 0.08,
        child: Image.asset(
          'assets/images/Abhyaz.jpg', // Replace with your image path
          fit: BoxFit.fitWidth,
        )
      ),
    ),
      Form(key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Image.asset('assets/images/feed.jpg'),
            Text("We sincerely appreciate you taking the time to provide us with your valuable feedback", style: TextStyle(fontSize: 20, color: Colors.black45),),
            SizedBox(height: 30,),
            Center(child: Text("Please fill out this form", style: TextStyle(color:Colors.blue.shade800, fontSize: 20 ),)),
            SizedBox(height: 17,),
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("Name", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 90,),
                    Expanded(
                      child: TextField(
                        controller: yournameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFFC5C5C5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("Email", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 93,),
                    Expanded(
                      child: TextField(
                        controller: emailidController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFFC5C5C5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("Department", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 41,),
                    Expanded(
                      child: TextField(
                        controller: deptController,
                        decoration: InputDecoration(
                          labelText: "of internship",
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFFC5C5C5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("Duration", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 68,),
                    Expanded(
                      child: TextField(
                        controller: durationController,
                        decoration: InputDecoration(
                          labelText: "In Months",
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Color(0xFFC5C5C5),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7,),
                Row(
                  children: [
                    CountryCodePicker(showDropDownButton: true,
                      onChanged: (CountryCode code) {
                        // Handle the selected country code
                        print(code.dialCode);
                      },
                      initialSelection: 'IN', // Set the initial country
                      favorite: ['+91', 'IN'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                  ],
                )
              ],
            ),
            SizedBox(height: 30,),
            Center(child: Text("Rate Us", style: TextStyle(color:Colors.blue.shade800, fontSize: 20 ),)),
            SizedBox(height: 17,),
            // SizedBox(height: 50,),
            Text(
              "1. How would you rate your experience as an intern at Abhyaz?",
              style: TextStyle(
                  fontSize: 17
              ),
            ),
          RatingBar.builder(
            initialRating: 0,itemSize: 30,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.blue.shade800,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              setState(() {
                userRating1 = rating;
              });
            },
          ),
            SizedBox(height: 20,),
            Text(
              "2. How likely did we match your expectations?",
              style: TextStyle(
                  fontSize: 17
              ),
            ),

            RatingBar.builder(
              initialRating: 0,itemSize: 30,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.blue.shade800,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  userRating2 = rating;
                });
              },
            ),
            SizedBox(height: 20,),
            Text(
              "3. How relevant did you consider this opportunity for your skill development?",
              style: TextStyle(
                   fontSize: 17
              ),
            ),
            RatingBar.builder(
              initialRating: 0,itemSize: 30,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.blue.shade800,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  userRating3 = rating;
                });
              },
            ),
            SizedBox(height: 20,),
            Text(
              "4. Rate the working culture at Abhyaz??",
              style: TextStyle(
                   fontSize: 17
              ),
            ),

            RatingBar.builder(
              initialRating: 0,itemSize: 30,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.blue.shade800,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  userRating4 = rating;
                });
              },
            ),
            SizedBox(height: 20,),

            Text(
              "5. How likely are you to recommend Abhyaz to others?",
              style: TextStyle(
                   fontSize: 17
              ),
            ),

            RatingBar.builder(
              initialRating: 0,itemSize: 30,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.blue.shade800,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  userRating5 = rating;
                });
              },
            ),

            SizedBox(height: 30,),
            Column(
              children: [
                Text(
                  "Other Feedbacks apart from internships?",
                  style: TextStyle(
                      color: Color(0xFFC5C5C5), fontSize: 25
                  ),
                ),
                Text(
                  "Please Select the type of the feedback",
                  style: TextStyle(
                      color: Colors.blue.shade800, fontSize: 25
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            GestureDetector(
              child: buildCheckItem(
                  title: "Login trouble", isSelected: isTypeSelected[0]),
              onTap: () {
                setState(() {
                  isTypeSelected[0] = !isTypeSelected[0];
                });
              },
            ),
            GestureDetector(
              child: buildCheckItem(
                  title: "Phone number related", isSelected: isTypeSelected[1]),
              onTap: () {
                setState(() {
                  isTypeSelected[1] = !isTypeSelected[1];
                });
              },
            ),
            GestureDetector(
              child: buildCheckItem(
                  title: "Personal profile", isSelected: isTypeSelected[2]),
              onTap: () {
                setState(() {
                  isTypeSelected[2] = !isTypeSelected[2];
                });
              },
            ),
            GestureDetector(
              child: buildCheckItem(
                  title: "Other issues", isSelected: isTypeSelected[3]),
              onTap: () {
                setState(() {
                  isTypeSelected[3] = !isTypeSelected[3];
                });
              },
            ),
            GestureDetector(
              child: buildCheckItem(
                  title: "Suggestions", isSelected: isTypeSelected[4]),
              onTap: () {
                setState(() {
                  isTypeSelected[4] = !isTypeSelected[4];
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            buildFeedbackForm(),
            SizedBox(height: 20.0),
            Spacer(),
            Column( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isSubmitting = true;
                    });
                    print(feedbackController.text);
                    bool _formisvalid = _formKey.currentState!.validate();
                    if(!!_formisvalid){
                      String message;
                      List<String> selectedCheckItems = [];
                      for (int i = 0; i < isTypeSelected.length; i++) {
                        if (isTypeSelected[i]) {
                          // Assuming you have a list of check items
                          List<String> checkItems = [
                            "Login trouble",
                            "Phone number related",
                            "Personal profile",
                            "Other issues",
                            "Suggestions",
                          ];
                          selectedCheckItems.add(checkItems[i]);
                        }
                      }
                      try{
                        final collection = FirebaseFirestore.instance.collection('feedback');
                        String imageURL = await uploadImageToFirebase();
                        await collection.add({
                          'timestamp': FieldValue.serverTimestamp(),
                          'Name' : yournameController.text,
                          'Email': emailidController.text,
                          'Department': deptController.text,
                          'Duration': durationController.text,
                          'Phone Number': phoneController.text,
                          'Experience': userRating1,
                          'Expectations': userRating2,
                          'Relevant': userRating3,
                          'Culture': userRating4,
                          'Recommend': userRating5,
                          'Feedback': feedbackController.text,
                          'Screenshot': imageURL,
                          'Type of Feedback': selectedCheckItems,

                        });
                        message = "Feedback Submitted";
                      } catch (_){
                        message = "Oops, Something wrong";
                      }
                      setState(() {
                        isSubmitting = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.green, // Set your desired background color
                          behavior: SnackBarBehavior.fixed, // This will make the SnackBar appear at the top
                        ),
                      );

                      // Navigator.pop(context);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FinishPage(),
                      ),
                    );

                    },
                  child: isSubmitting
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                  : Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade800)

                ),
                )],
            )
          ],
        ),
      ),
])

    );

  }

  buildFeedbackForm() {
    // TextEditingController feedbackController = TextEditingController();

    return Container(
      height: 200,
      child: Stack(
        children: [
          TextField(
            controller: feedbackController,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "Please briefly describe the issue",
              hintStyle: TextStyle(
                fontSize: 13.0,
                color: Color(0xFFC5C5C5),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE5E5E5),
                ),
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {print(feedbackController.text);},
          //   child: Container(
          //     child: Icon(Icons.feedback, color: Colors.blueAccent),
          //     margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: Color(0xFFA6A6A6),
                  ),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    child:  Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: Color(0xFFA5A5A5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Upload screenshot (optional)",
                    style: TextStyle(
                      color: Color(0xFFC5C5C5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedImage != null)
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Image.file(
                _selectedImage!,
                width: 50.0,
                height: 50.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCheckItem({required String title, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey),
          ),
        ],
      ),
    );
  }
}
