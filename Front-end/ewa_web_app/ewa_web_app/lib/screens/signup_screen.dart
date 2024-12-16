import 'package:ewa_web_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colors/primary_colors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Text editing controllers for the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  String _errorMessage = ''; // Error message if sign-up fails

  // Function to handle sign-up button pressed
  Future<void> _signUp() async {
    try {
      // Create a user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to the home screen after successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } catch (error) {
      setState(() {
        // Update error message to display the error to the user
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColors.screencolorgrey,
      body: Center(
        child: Container(
          width: 400,
          height: 500,
          decoration: BoxDecoration(
            color: PrimaryColors.screencolorgrey,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: Colors.black87,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/SmallBot.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
                Center(
                  child: const Text(
                    'E.W.A',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: PrimaryColors.textcolorblack,
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                // Text field for name input
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: PrimaryColors.textcolorwhite),
                  cursorColor: PrimaryColors.textcolorwhite,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: PrimaryColors.textcolorwhite),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: PrimaryColors.screencolorblack,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Text field for email input
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: PrimaryColors.textcolorwhite),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: PrimaryColors.textcolorwhite),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: PrimaryColors.screencolorblack,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Text field for password input
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: PrimaryColors.textcolorwhite),
                  cursorColor: Colors.white,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontWeight: FontWeight.w100, color: Colors.white),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: PrimaryColors.screencolorblack,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                // Display error message if sign-up fails
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20.0),
                // Button to sign up
                Padding(
                  padding: const EdgeInsets.only(left: 120, right: 120),
                  child: ElevatedButton(
                    onPressed: _signUp, // Call the sign-up function when button is pressed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColors.textcolorblack,
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: PrimaryColors.textcolorwhite),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
