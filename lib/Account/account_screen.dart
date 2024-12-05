import 'package:flutter/material.dart';
import 'package:finance_tracker/Elements/widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  static String localFile = '';
  static bool isLocal=false;
  static bool isLogOut = false;

  static String user = '';
  static String name = '';
  static String phoneNumber = '';
  static String joiningDate = '';
  static String std = '';
  static String picture = '';
  

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: accountScreenAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 50,left: 25,right: 25),
        child: Column(
          children: [
      
            profilePicture(),
            SizedBox(height: screen.height*0.025),
      
      
            accountName(AccountScreen.name),
            SizedBox(height: screen.height*0.05),
      
            Container(
              width: double.infinity, height: 2,
              decoration: const BoxDecoration(color: accentColor2),
            ),
            SizedBox(height: screen.height*0.05),
      
            accountDetails('Academic Post :\t\t\t${AccountScreen.user}'),
            SizedBox(height: screen.height*0.025),
      
            accountDetails('Phone Number : \t\t\t+91 ${AccountScreen.phoneNumber}'),
            SizedBox(height: screen.height*0.025),

            (AccountScreen.joiningDate.isNotEmpty) ? accountDetails('Joining Date : \t\t\t${AccountScreen.joiningDate}') : const Text(''),
            SizedBox(height: screen.height*0.025),
            
            (AccountScreen.std.isNotEmpty) ? accountDetails('Class : \t\t\t${AccountScreen.std}') : const Text(''),
            SizedBox(height: screen.height*0.025),      
          ],
        ),
      ),
    );
  }
}