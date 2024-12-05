import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/functions.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/Account/Login/otp_screen.dart';
import 'package:finance_tracker/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static bool isUserExist = false;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phoneNumber = TextEditingController();
  bool isLoading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: accentColor1,
        title: loginTitleText('INFINITY ACADEMY'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            headingText('${MyApp.user} Login', true),
            headingText(selectSubHeading(),false),
            const SizedBox(height: 20),
      
            phoneTextFormField(phoneNumber),
            const SizedBox(height: 10),
      
            Text(error,style: const TextStyle(color: Colors.redAccent,fontSize: 15)),
            const SizedBox(height: 10),
            
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  await userCheck(phoneNumber.text);
                  setState(() {error = '';});

                  if(phoneNumber.text.isEmpty) {
                    setState(() {error = 'Phone Number is Required';});
                  } 
                  else if(phoneNumber.text.length != 10) {
                    setState(() {error = 'Invalid Phone Number';});
                  } 
                  else if(!LoginScreen.isUserExist) {
                    setState(() {error = 'This number is not verified as ${MyApp.user}';});
                  } 
                  else {
                    setState(() {isLoading = true;});
                    MyApp.phoneNumber = phoneNumber.text;

                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+91${MyApp.phoneNumber}',

                      verificationCompleted: (PhoneAuthCredential credential) {},

                      verificationFailed: (FirebaseAuthException e) {
                        setState(() {isLoading = false;});
                        if(e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
                          setState(() {error = 'Network Problem';});
                        } 
                        else {
                          setState(() {error = 'Invalid Phone Number';});
                        }
                      },

                      codeSent: (String verificationId, int? resendToken) {
                        OtpScreen.verify = verificationId;
                        setState(() {isLoading = false;});
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const OtpScreen()));
                      },
                      
                      codeAutoRetrievalTimeout: (String verificationId) {
                        isLoading ? setState(() {isLoading = false;}) : null; 
                      },
                    );
                  }
                },
                style: buttonStyle(),
                child: isLoading ? const SizedBox( height: 25, width: 25, child: CircularProgressIndicator.adaptive(strokeWidth: 3,valueColor: AlwaysStoppedAnimation<Color>(Colors.white70))) : buttonText('Send OTP'),
              ),
            ),
            const SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
      
                TextButton(
                  onPressed: () {setState(() {userSwitch(true);});},
                  child: Text(userSwitchText(true,context),
                    style: textStyle(Colors.white70, 15, FontWeight.w400, 1, 0.25),
                  ),
                ),
      
                loginTitleText('|'),
      
                TextButton(
                  onPressed: () {setState(() {userSwitch(false);});},
                  child: Text(userSwitchText(false,context),
                    style: textStyle(Colors.white70, 15, FontWeight.w400, 1, 0.25),
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