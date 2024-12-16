import 'package:ewa_web_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ewa_web_app/screens/chat_screen.dart';

import '../colors/primary_colors.dart'; // Import the WelcomeScreen widget

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      // Sign in user with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to the welcome screen after successful login
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
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: PrimaryColors.textcolorwhite),
                  cursorColor: PrimaryColors.textcolorwhite,
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
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(left: 120, right: 120),
                  child: ElevatedButton(
                    onPressed: _login, // Call _login function when button is pressed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColors.textcolorblack,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: PrimaryColors.textcolorwhite),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()), // Navigate to SignUpScreen
                    ); // Add navigation to the registration screen
                  },
                  child: Center(
                    child: Text(
                      'Do not have an account? Create',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: PrimaryColors.textcolorblack,
                        decoration: TextDecoration.underline,
                      ),
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
