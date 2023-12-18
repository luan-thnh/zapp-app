import 'dart:async';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/screens/otp_confirmation_screen.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController otpController;

  const OtpInput({Key? key, required this.otpController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 72,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: TypographyTheme.headingBig(fontWeight: FontWeight.w900),
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: InputDecoration(
          hintText: ('0'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.myauth, required this.userEmail})
      : super(key: key);
  final EmailOTP myauth;
  final String userEmail;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  late Timer _timer;
  int _remainingTime = 120;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_remainingTime == 0) {
          setState(() {
            timer.cancel();
            _isButtonDisabled = true; // Khóa nút "Continue"
          });
        } else {
          setState(() {
            _remainingTime--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool disableButton() {
    return _isButtonDisabled || _remainingTime <= 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter OTP",
              style: TypographyTheme.headingBig(fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TypographyTheme.heading3(
                  fontWeight: FontWeight.w500,
                  color: ColorsTheme.grey,
                ),
                children: [
                  TextSpan(
                    text: 'An Authentication code has been sent to ',
                  ),
                  TextSpan(
                    text: '${widget.userEmail}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(otpController: otp1Controller),
                OtpInput(otpController: otp2Controller),
                OtpInput(otpController: otp3Controller),
                OtpInput(otpController: otp4Controller),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: disableButton()
                    ? null
                    : () async {
                        if (await widget.myauth.verifyOTP(
                                otp: otp1Controller.text +
                                    otp2Controller.text +
                                    otp3Controller.text +
                                    otp4Controller.text) ==
                            true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("OTP is verified"),
                          ));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPConfirmationScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid OTP"),
                          ));
                        }
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Code Sent. Resend Code in ",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
