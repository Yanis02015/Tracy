import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'delayed_animation.dart';
import 'main.dart';
import 'connexionpage.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF66C3EC),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 30,
          ),
          child: Column(
            children: [
              DelayedAnimation(
                delay: 1500,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 170,
                  child: Image.asset('images/bird.png'),
                ),
              ),
              DelayedAnimation(
                delay: 2500,
                child: Container(
                  height: 400,
                  margin: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Image.asset('images/traveling.jpg'),
                ),
              ),
              DelayedAnimation(
                delay: 3500,
                child: Container(
                  child: Text(
                    "Bienvenue sur TRACY , votre meilleur compagnion sur les routes de Béjaia",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: dYollow,
                      fontSize: 18,
                    ),
                  ),
                  margin: EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                ),
              ),
              DelayedAnimation(
                delay: 4500,
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: dYollow,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(13),
                    ),
                    child: Text(
                      "COMMENCER",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChosePage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
