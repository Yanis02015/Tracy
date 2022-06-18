import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracy/data_response.dart';
import 'delayed_animation.dart';
import 'signup_page.dart';
import 'forget_page.dart';
import 'package:tracy/user.dart';
import 'main.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtain shared preferences.
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
                    child: Container(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                          ),
                          Text(
                            "Connexion",
                            style: GoogleFonts.poppins(
                              color: dYollow,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  DelayedAnimation(
                    delay: 1500,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                        ),
                        Text(
                          " Accedez a votre compte grâce a votre email et mot de passe",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  LoginForm(),
                  SizedBox(height: 20),
                  DelayedAnimation(
                    delay: 3800,
                    child: Container(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PasswordPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Mot de passe oublié",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(width: 50),
                          Align(
                            alignment: Alignment.centerRight,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Crée un nouveau compte",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 35),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: DelayedAnimation(
                          delay: 4000,
                          child: Text(
                            "SKIP",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  String email = '', password = '', code = '';
  bool _isButtonDisabled = false;

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DelayedAnimation(
            delay: 2000,
            child: TextFormField(
              validator: (value) => validateEmail(value),
              decoration: InputDecoration(
                labelText: 'Votre Email',
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              onSaved: (value) {
                email = value.toString();
              },
            ),
          ),
          SizedBox(height: 35),
          DelayedAnimation(
            delay: 2200,
            child: TextFormField(
              obscureText: _isObscure,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.blueGrey,
                ),
                labelText: "Mot de passe",
                suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              onSaved: (value) {
                password = value.toString();
              },
            ),
          ),
          SizedBox(height: 30),
          DelayedAnimation(
            delay: 500,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  final DataRes dr =
                      await UserRestApi().loginUser(email, password);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(dr.message)),
                  );
                  if (dr.statusCode == 403) {
                    openDialogConfirmEmail();
                  }
                  if (dr.statusCode == 200) {
                    // TODO ROUTE TO HOME
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
        ],
      ),
    );
  }

  final confirmeMessage = 'Confirmation de l\'email nécessaire';
  Future openDialogConfirmEmail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(confirmeMessage),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: 'Entrer le code à 6 chiffres'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(6)
              ],
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () async {
                          setState(() {
                            _isButtonDisabled = true;
                          });
                          final DataRes drSendCode =
                              await UserRestApi().sendCodeOnEmail(email);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(drSendCode.message)));
                          setState(() {
                            _isButtonDisabled = false;
                          });
                        },
                  child: Text(!_isButtonDisabled
                      ? 'Renvoyé le code'
                      : 'Envoi en cours...')),
              TextButton(
                  onPressed: () async {
                    final DataRes drSendCode = await UserRestApi()
                        .confirmeEmailUser(email, controller.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(drSendCode.message)));
                  },
                  child: const Text('Confirmer')),
            ],
          ));
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
