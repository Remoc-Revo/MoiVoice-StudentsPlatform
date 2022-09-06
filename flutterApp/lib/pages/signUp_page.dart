import 'package:flutter/material.dart';
import 'package:moivoice/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  late String email, password1, password2, phone, name, admission;
  late String confirmedPassword;
  var errorMessage = "";
  @override
  Widget build(BuildContext Context) {
    return Material(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("MoiVoice",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 34,
                )),
            Padding(
              padding: EdgeInsets.all(13.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'user name',
                  hintText: 'Enter your preffered user name',
                ),
                onChanged: (val) {
                  name = val;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(13.0),
              child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter  valid email eg. tstap2@pro.com',
                  ),
                  onChanged: (val) {
                    email = val;
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(13.0),
              child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Admission Number',
                    hintText: 'Enter  your Admission Number eg. com-1221-12',
                  ),
                  onChanged: (val) {
                    admission = val;
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(13.0),
              child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your  Password',
                  ),
                  onChanged: (val) {
                    password1 = val;
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(13.0),
              child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your  Password',
                  ),
                  onChanged: (val) {
                    password2 = val;
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(13.0),
              child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    hintText: 'Enter  vour Phone Number',
                  ),
                  onChanged: (val) {
                    phone = val;
                  }),
            ),
            Text(errorMessage,
                style: TextStyle(
                  color: Colors.red,
                )),
            Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () {
                    //initialize the errorMessage to ensure previous error messages
                    //are not displayed when they reoccur on proceeding submits
                    errorMessage = '';

                    //confirm if email has correct format
                    if (!RegExp(
                            r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9]+.[A-Za-z]{2,}$')
                        .hasMatch(email)) {
                      errorMessage += "\n Invalid email ";
                    }

                    //confirm if admission number is in the right format
                    if (!RegExp(r'^[a-z]{2,4}-[0-9]{4}-[0-9]{2}$')
                        .hasMatch(admission)) {
                      errorMessage += "\n Invalid admission number format";
                    }

                    //confirm if both entered passwords match
                    if (password1 == password2) {
                      confirmedPassword = password1;

                      //ensure password is at least 8 characters long
                      if (confirmedPassword.length < 8) {
                        errorMessage +=
                            "\n Password must be atleast 8 characters";
                      }
                    } else {
                      errorMessage += "Passwords doesn't match";
                    }

                    //ensure he phone has 10 digits
                    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                      errorMessage += "\n Phone number must be 10 digits";
                    }

                    if (errorMessage == '') {
                      Provider.of<AuthProvider>(context, listen: false)
                          .signUpUser(
                              name, email, admission, confirmedPassword, phone);
                    }
                    print(AuthProvider.signup_authMessage);
                    if (AuthProvider.signup_authMessage == 'success') {
                      Navigator.pushNamed(context, "/home");
                    }

                    setState(() {
                      errorMessage += AuthProvider.errorMessage;
                    });
                  },
                  child: Text('create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      )),
                )),
          ]),
    );
  }
}
