import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'delayed_animation.dart';
import 'main.dart';

class PhonePage extends StatelessWidget {
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
                      "Veuilliez introduire votre numéro de téléphone afin de recupérer votre compte",
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
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DelayedAnimation(
            delay: 1200,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'TEL',
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
                isVisible = !isVisible;
                setState(() {});
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
          DelayedAnimation(
            delay: 1600,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Utiliser votre adresse email",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Visibility(
            visible: isVisible,
            child: Column(
              children: [
                DelayedAnimation(
                  delay: 1200,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Code',
                      labelStyle: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DelayedAnimation(
                  delay: 1200,
                  child: ElevatedButton(
                    onPressed: () {},
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
