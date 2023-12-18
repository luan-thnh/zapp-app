import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/otp_confirmation_screen.dart';
import 'package:messenger/screens/otp_send.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  EmailOTP myauth = EmailOTP();

  Future<void> _submitEmail(BuildContext context) async {
    if (emailController.text.isNotEmpty) {
      myauth.setConfig(
        appEmail: "contact@hdevcoder.com",
        appName: "Email OTP",
        userEmail: emailController.text,
        otpLength: 4,
        otpType: OTPType.digitsOnly,
      );
      if (await myauth.sendOTP()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP has been sent"),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              myauth: myauth,
              userEmail:
                  emailController.text, // Truyền giá trị email sang OtpScreen
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oops, OTP send failed"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Quay lại trang trước đó
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Màu viền bạn có thể thay đổi tại đây
            width: 0.2,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot password?',
              style: TypographyTheme.headingBig(fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 16),
            Text(
              'Enter your email address or phone number. If an account exists, you will get an activation code.',
              style: TypographyTheme.heading3(
                fontWeight: FontWeight.w500,
                color: ColorsTheme.grey,
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Your email or phone number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _submitEmail(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: ColorsTheme.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
