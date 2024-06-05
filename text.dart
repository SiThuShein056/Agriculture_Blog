

////////////////////////////////////////////
///            Change Pw                ///
//////////////////////////////////////////


// var currentUser = FirebaseAuth.instance.currentUser;
//   changePassword(email, newpass, oldpass) async {
//     var cred = EmailAuthProvider.credential(email: email, password: oldpass);
//     await currentUser!.reauthenticateWithCredential(cred).then((value) {
//       currentUser!.updatePassword(newpass);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Success"),
//         ),
//       );
//       Navigator.of(context).pop();
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             error.toString(),
//           ),
//         ),
//       );
//     });
//   }


////////////////////////////////////////////
///            Generate pw              ///
//////////////////////////////////////////


// String generatePassword({
//   bool hasLetters = true,
//   bool hasNumbers = true,
//   bool hasSpecial = true,
// }) {
//   final length = 20;
//   final lettersLowercase = 'abcdefghijklmnopqrstuvwxyz';
//   final lettersUppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//   final numbers = '0123456789';
//   final special = '@#=+!\$%&>?(){}';

//   String chars = '';
//   if (hasLetters) chars += '$lettersLowercase$lettersUppercase';
//   chars += '$numbers';
//   chars += '$special';
//   return List.generate(length, (index) {
//     final indexRandom = Random().nextInt(chars.length);
//     return chars[indexRandom];
//   }).join('');
// }


////////////////////////////////////////////
///            Change Mail              ///
//////////////////////////////////////////


// changeMail(email, pass, newMail) async {
//     var cred = EmailAuthProvider.credential(email: email, password: pass);
//     await currentUser!.reauthenticateWithCredential(cred).then((value) {
//       currentUser!.updateEmail(newMail);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "Success",
//           ),
//         ),
//       );
//       // Navigator.of(context).pop();
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             error.toString(),
//           ),
//         ),
//       );
//     });
//   }


////////////////////////////////////////////
///                Screen OTP           ///
//////////////////////////////////////////




// onTap: () async {
//     myauth.setConfig(
//         appEmail: "hhtz12450@gmail.com",
//         appName: "EmailOTP",
//         userEmail: _mailControler.text,
//         otpLength: 6,
//         otpType: OTPType.digitsOnly);
//     if (await myauth.sendOTP() == true) {
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) {
//         return OtpScreen(
//             myauth: myauth, mail: _mailControler.text);
//       }));
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Otp has been sent")));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Otp sent fail")));
//     }
// }

/////////////////////////////////////////////////////////////////////////////////

//  Pinput(
//         length: 6,
//         showCursor: true,
//         onChanged: (value) {
//           code = value;
//         },
//       ),

// ElevatedButton(
//     onPressed: () async {
//       if (await myauth.verifyOTP(otp: code.toString()) ==
//           true) {
//         try {
//           await auth.sendPasswordResetEmail(email: mail);

//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Success ")));

//           Navigator.of(context)
//               .push(MaterialPageRoute(builder: (context) {
//             return FinishPasswordChange();
//           }));
//         } on FirebaseAuthException catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(e.message!)));
//           return print(e);
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Invalid OTP")));
//       }
//     },
//     child: Text("Verify OTP")),
//////////////////////////////////////////////////////////////////////////////////rules_version = '2';

// Craft rules based on data in your Firestore database
// allow write: if firestore.get(
//    /databases/(default)/documents/users/$(request.auth.uid)).data.isAdmin;
// service firebase.storage {
//   match /b/{bucket}/o {

//     // This rule allows anyone with your Storage bucket reference to view, edit,
//     // and delete all data in your Storage bucket. It is useful for getting
//     // started, but it is configured to expire after 30 days because it
//     // leaves your app open to attackers. At that time, all client
//     // requests to your Storage bucket will be denied.
//     //
//     // Make sure to write security rules for your app before that time, or else
//     // all client requests to your Storage bucket will be denied until you Update
//     // your rules
//     match /{allPaths=**} {
//       allow read, write: if request.time < timestamp.date(2024, 3, 29);
//     }
//   }
// }

  // myauth.setConfig(
  //                           appEmail: "hhtz12450@gmail.com",
  //                           appName: "EmailOTP",
  //                           userEmail: _mailControler.text,
  //                           otpLength: 6,
  //                           otpType: OTPType.digitsOnly);
  //                       if (await myauth.sendOTP() == true) {
  //                         Navigator.of(context)
  //                             .push(MaterialPageRoute(builder: (context) {
  //                           return OtpScreen(
  //                               myauth: myauth, mail: _mailControler.text);
  //                         }));
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(content: Text("Otp has been sent")));
  //                       } else {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(content: Text("Otp sent fail")));
  //                       }
