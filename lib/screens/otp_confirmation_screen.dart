import 'package:flutter/material.dart';
import 'package:messenger/screens/login_screen.dart'; // Import the HomeScreen file
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

class OTPConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Confirmed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'OTP Confirmed!',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ColorsTheme.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
