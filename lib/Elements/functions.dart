import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';
import 'package:finance_tracker/Account/Login/login_screen.dart';
import 'package:finance_tracker/home_screen.dart';
import 'package:finance_tracker/main.dart';
import 'package:finance_tracker/Payment/payment.dart';

//------------------------------------------------
// ---------------Login Functions-----------------
//------------------------------------------------

// Checks weather user exist or not
Future<void> userCheck(String phoneNumber) async {
  final ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('User').child(MyApp.user).get();
    if (snapshot.hasChild(phoneNumber)) {
      LoginScreen.isUserExist = true;
      return;
    } 
    else {
      LoginScreen.isUserExist = false;
    }
}

// check weather user is signed in or not, if yes then navigate to respective home screen
Future<void> checkCurrentUser() async {
  final user = FirebaseAuth.instance.currentUser;

  if(user != null) {
    MyApp.phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!.toString().substring(3);
    final auth = FirebaseDatabase.instance;
    final ref = auth.ref();
    var snapshot = await ref.child('User').child('Admin').get();
    if (snapshot.hasChild(MyApp.phoneNumber)) {
      MyApp.user = 'Admin';
      return;
    }
    snapshot = await ref.child('User').child('Teacher').get();
    if (snapshot.hasChild(MyApp.phoneNumber)) {
      MyApp.user = 'Teacher';
      return;
    }
    snapshot = await ref.child('User').child('Student').get();
    if (snapshot.hasChild(MyApp.phoneNumber)) {
      MyApp.user = 'Student';
      return;
    }
  }
}

// select the sub-heading for user for login screen
String selectSubHeading() {
  if(MyApp.user == "Student") {
    return 'Login through your issued mobile number !';
  } 
  else if(MyApp.user == "Teacher") {
    return 'Only tution faculty members are allowed !';
  } 
  else if(MyApp.user == "Admin") {
    return 'Only administration members are allowed !';
  }
  return '';
}

// select the user switch text in login screen
String userSwitchText(bool isleft, context) {
  if(MyApp.user == "Student") {
    if(isleft) {
      return 'Admin';
    } else {
      return 'Teacher';
    }
  }
  else if(MyApp.user == "Teacher") {
    if(isleft) {
      return 'Admin';
    } else {
      return 'Student';
    }
  }
  else if(MyApp.user == "Admin") {
    if(isleft) {
      return 'Student';
    } else {
      return 'Teacher';
    }
  }
  return '';
}

// Change the login screen for different users
void userSwitch(bool isleft) {
  if(MyApp.user == "Student") {
    if(isleft) {
      MyApp.user = 'Admin';
    } else {
      MyApp.user = 'Teacher';
    }
  }
  else if(MyApp.user == "Teacher") {
    if(isleft) {
      MyApp.user = 'Admin';
    } else {
      MyApp.user = 'Student';
    }
  }
  else if(MyApp.user == "Admin") {
    if(isleft) {
      MyApp.user = 'Student';
    } else {
      MyApp.user = 'Teacher';
    }
  }
}

//-----------------------------------------------
//------------Home Screen Functions--------------
//-----------------------------------------------

Future<void> getUserInformation() async {

  final databaseRef = FirebaseDatabase.instance.ref();
  var databaseSnapshot = await databaseRef.child('User').child(MyApp.user).child(MyApp.phoneNumber).get();
  if(databaseSnapshot.value != null) {
    if(MyApp.user == 'Admin') {
      HomeScreen.name = databaseSnapshot.child('Name').value.toString();
    }
    else if(MyApp.user == 'Teacher') {
      HomeScreen.name = databaseSnapshot.child('Name').value.toString();
      HomeScreen.joiningDate = databaseSnapshot.child('Joining Date').value.toString();
    }
    else if(MyApp.user == 'Student') {
      HomeScreen.name = databaseSnapshot.child('Name').value.toString();
      HomeScreen.joiningDate = databaseSnapshot.child('Joining Date').value.toString();
      HomeScreen.std = databaseSnapshot.child('Class').value.toString();
    }
  }
}

//-----------------------------------------------
//-----------Account Screen Functions------------
//-----------------------------------------------

// Log Out Funciton
void logoutAccount(context) {
  HomeScreen.name = '';
  MyApp.picture = '';
  MyApp.phoneNumber = '';
  FirebaseAuth.instance.signOut().then((value) => Navigator.push(context,MaterialPageRoute
  (builder: (context) => const LoginScreen())));
}

//-----------------------------------------------
//---------Add Member Screen Functions-----------
//-----------------------------------------------

String? validateName(String? formName) {
  if (formName == null || formName.isEmpty) {
    return 'Name is required';
  }
  return null;
}

String? validatePhone(String? formPhone) {
  if (formPhone == null || formPhone.isEmpty) {
    return 'Phone Number is required';
  }
  else if (formPhone.length != 10) {
    return 'Invalid Phone Number';
  }
  return null;
}

String? validateAmount(String? formDate) {
    if (formDate == null || formDate.isEmpty) {
      return 'Field is required';
    }
    return null;
  }

//-----------------------------------------------
//---------Member List Screen Functions----------
//-----------------------------------------------

Future<void> deletAccount(var context,var screen, var databaseRef, String name , String phoneNumber) async {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: widgetColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Are you sure to remove',style: textStyle(Colors.white70, 17, FontWeight.w400, 1, 0.25)),
          const SizedBox(height: 10),
          Text('$name ?',style: textStyle(Colors.white70, 17, FontWeight.w400, 1, 0.25)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => states.contains(MaterialState.pressed) ? null : accentColor1),
                ),
                onPressed: () async {
                  await databaseRef.child(phoneNumber).set(null).then((value) {Navigator.pop(context);});
                },
                child: Text('Yes',style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25)),
              ),
              SizedBox(width: screen.width*0.15),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => states.contains(MaterialState.pressed) ? null : accentColor1),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No',style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25)),
              ),
              ],
            ),
          ],
        ),
      );
    }
  );
}

//-----------------------------------------------
//---------Payment Screen Function---------------
//-----------------------------------------------

// Function to store fees payment information in database
Future<void> feesPayment(var context,var amount, String day, String month, String year) async {
  try {
    final databaseRef = FirebaseDatabase.instance.ref('Payment').child('Fees').child('${PaymentScreen.phoneNumber} - $day $month $year');
    databaseRef.set({
      'Name' : PaymentScreen.name,
      'Class' : PaymentScreen.std,
      'Phone Number' : PaymentScreen.phoneNumber,
      'Amount' : amount.text,
      'Date' : '$day $month $year',
      'By' : HomeScreen.name,
    });
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Successfully Saved !',style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                amount = TextEditingController(text: '');
                Navigator.pop(context);
              },
              child: const Text('OK',style: TextStyle(color: Colors.white,fontSize: 17.5)),
            ),
          ],
        ),
      );
    });
  } on FirebaseException catch (error) {
    print(error);
  }
}

// Function to store salary payment information in database
Future<void> salaryPayment(var context,var amount, String day, String month, String year) async {
  try {
    final databaseRef = FirebaseDatabase.instance.ref('Payment').child('Salary').child('${PaymentScreen.phoneNumber} - $day $month $year');
    databaseRef.set({
      'Name' : PaymentScreen.name,
      'Phone Number' : PaymentScreen.phoneNumber,
      'Amount' : amount.text,
      'Date' : '$day $month $year',
      'By' : HomeScreen.name,
    });
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Successfully Saved !',style: textStyle(Colors.white70, 17, FontWeight.w500, 1, 0.25)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                amount = TextEditingController(text: '');
                Navigator.pop(context);
              },
              child: const Text('OK',style: TextStyle(color: Colors.white,fontSize: 17.5)),
            ),
          ],
        ),
      );
    });
  } on FirebaseException catch (error) {
    print(error);
  }
}

//-----------------------------------------------
//---------Add Member Screen Function -----------
//-----------------------------------------------
