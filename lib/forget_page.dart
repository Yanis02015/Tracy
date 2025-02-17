import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracy/data_response.dart';
import 'package:tracy/phonepage.dart';
import 'package:tracy/set_code_forget_password.dart';
import 'package:tracy/user.dart';
import 'delayed_animation.dart';
import 'main.dart';

class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF66C3EC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedAnimation(
                    delay: 1000,
                    child: Text(
                      "Mot De Passe Oublié",
                      style: GoogleFonts.poppins(
                        color: dYollow,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  DelayedAnimation(
                    delay: 1100,
                    child: Text(
                      "Veuilliez introduire votre adresse email afin de recupérer votre compte",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ForgotPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  String email = '';
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              DelayedAnimation(
                delay: 1200,
                child: TextFormField(
                  validator: (value) => validateEmail(value),
                  onSaved: (value) {
                    email = value.toString();
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'votre Email',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              DelayedAnimation(
                delay: 1400,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final DataRes dr = await UserRestApi()
                          .sendEmailCodeForgetPassword(email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(dr.message)),
                      );
                      if (dr.statusCode == 200) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CodeResetPage(email: email),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    primary: dYollow,
                    padding: EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 125,
                    ),
                  ),
                  child: Text(
                    "CONFIRMER",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Enter a valid email address';
  else
    return null;
}
