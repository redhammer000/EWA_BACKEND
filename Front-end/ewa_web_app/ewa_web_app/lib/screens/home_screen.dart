import 'package:ewa_web_app/colors/primary_colors.dart';
import 'package:ewa_web_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Path to your background image asset
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Container(
            color: Colors.transparent, // Make the container transparent to allow the background image to show
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'E.W.A',
                      style: TextStyle(
                        color: PrimaryColors.textcolorwhite,
                        fontWeight: FontWeight.w100,
                        fontSize: screenWidth * 0.03, // Adjust the font size based on screen width
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjust spacing based on screen height
                    Image.asset(
                      'assets/images/Bot1.png',
                      width: screenWidth * 0.2, // Adjust the width of the image based on screen width
                      height: screenWidth * 0.2, // Adjust the height of the image based on screen width
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      'How can I help you?',
                      style: TextStyle(
                        color: PrimaryColors.textcolorwhite,
                        fontWeight: FontWeight.w100,
                        fontSize: 12, // Adjust the font size based on screen width
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjust spacing based on screen height
                    Container(
                      width: screenWidth * 0.3, // Adjust the width of the button based on screen width
                      height: screenHeight * 0.05, // Adjust the height of the button based on screen height
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },

                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(PrimaryColors.textcolorwhite,),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Start a New Chat!',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16, // Adjust the font size based on screen width
                            color: PrimaryColors.textcolorblack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
