import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/otp_send.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/utils/validate_field_util.dart';
import 'package:messenger/widgets/button_widget.dart';
import 'package:messenger/widgets/input_control_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  EmailOTP myauth = EmailOTP();
  bool isSendingEmail = false;

  Future<void> _submitEmail(BuildContext context) async {
    if (isSendingEmail) {
      return; // Nếu đang gửi email, không làm gì cả
    }

    setState(() {
      isSendingEmail = true; // Đánh dấu rằng đang gửi email
    });

    try {
      if (emailController.text.trim().isNotEmpty) {
        myauth.setConfig(
          appEmail: "contact@hdevcoder.com",
          appName: "Email OTP",
          userEmail: emailController.text.trim(),
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
                userEmail: emailController.text.trim(),
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
    } finally {
      setState(() {
        isSendingEmail = false; // Đánh dấu rằng việc gửi email đã hoàn thành
      });
    }
  }

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

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
        child: Form(
          key: _key,
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
              InputControlWidget(
                controller: emailController,
                hintText: "Please enter your email",
                obscureText: false,
                validator: ValidateFieldUtil.validatePhoneNumberOrEmail,
              ),
              SizedBox(height: 32),
              TextButton(
                onPressed: isSendingEmail
                    ? null
                    : () {
                        if (_key.currentState!.validate()) {
                          print('object');
                          _submitEmail(context);
                        }
                      },
                style: TextButton.styleFrom(
                    primary: ColorsTheme.primary,
                    backgroundColor: isSendingEmail
                        ? ColorsTheme.light
                        : ColorsTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    minimumSize: Size(mq.width, 50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSendingEmail)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            color: ColorsTheme.lightDark),
                      ),
                    if (isSendingEmail) const SizedBox(width: 12),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Continue',
                        style: TypographyTheme.heading5(
                            color: isSendingEmail
                                ? ColorsTheme.lightDark
                                : ColorsTheme.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
