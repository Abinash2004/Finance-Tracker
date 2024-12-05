import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/home_screen.dart';
import 'package:finance_tracker/main.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  static String verify = '';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final otpCode = TextEditingController();
  bool isLoading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: accentColor1,
        title: Center(
          child: loginTitleText('INFINITY ACADEMY'),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            headingText('Enter OTP', true),
            headingText('We have sent OTP to ${MyApp.phoneNumber}', false),
            const SizedBox(height: 20),

            pinPutOTP(otpCode),
            SizedBox(height: screen.height*0.015),
      
            Text(error,style: const TextStyle(color: Colors.redAccent,fontSize: 15)),
            SizedBox(height: screen.height*0.015),
      
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {error = '';});
                  
                  if(otpCode.text.isEmpty) {
                    setState(() {error = 'OTP is Required';});
                  } 
                  else if(otpCode.text.length < 6) {
                    setState(() {error = 'Invalid OTP';});
                  } 
                  else {
                    try{
                      setState(() {isLoading = true;});

                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: OtpScreen.verify,
                        smsCode: otpCode.text,
                      );
                        await auth.signInWithCredential(credential).then((value) {
                          setState(() {isLoading = false;});Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen()));
                        });
                    } on FirebaseAuthException catch(e) {
                      setState(() {isLoading = false;});
                      if(e.message == 'The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.') {
                        setState(() {error = 'Invalid OTP';});
                      } 
                      else if(e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
                        setState(() {error = 'Network Problem';});
                      } 
                      else {
                        setState(() {error = e.message.toString();});
                      }
                    }
                  }
                },
                style: buttonStyle(),
                child: isLoading ? const SizedBox( height: 25, width: 25, child: CircularProgressIndicator.adaptive(strokeWidth: 3,valueColor: AlwaysStoppedAnimation<Color>(Colors.white70))) : buttonText('Verify OTP'),
              ),
            ),
            
            TextButton(
                  onPressed: () {Navigator.pop(context);},
                  child: Text('Change Mobile Number',
                    style: textStyle(Colors.white70, 15, FontWeight.w400, 1, 0.25),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}