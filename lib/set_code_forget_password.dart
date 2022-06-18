import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracy/data_response.dart';
import 'package:tracy/phonepage.dart';
import 'package:tracy/set_code_forget_password.dart';
import 'package:tracy/user.dart';
import 'delayed_animation.dart';
import 'main.dart';
import 'package:flutter/services.dart';

class CodeResetPage extends StatelessWidget {
  const CodeResetPage({super.key, required this.email});
  final String email;

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
                      "Veuilliez introduire le code reçu à votre email",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CodeForgotPage(email),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeForgotPage extends StatefulWidget {
  CodeForgotPage(this.email);
  final String email;

  @override
  State<CodeForgotPage> createState() => _CodeForgotPageState(email);
}

class _CodeForgotPageState extends State<CodeForgotPage> {
  _CodeForgotPageState(this.email);
  String email;
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
    final formKey = GlobalKey<FormState>();
    String code = '';

    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              DelayedAnimation(
                delay: 1200,
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Entrer le code à 6 chiffres'),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    code = value.toString();
                  },
                ),
              ),
              SizedBox(height: 40),
              DelayedAnimation(
                delay: 1400,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
                      final DataRes dr = await UserRestApi()
                          .confirmeCodeForgetPassword(email, code);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(dr.message)));
                      if (dr.statusCode == 200) {
                        openDialogSetNewPassword(code);
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

  final confirmeMessage = 'Nouveau mot de passe';
  Future openDialogSetNewPassword(String code) {
    final formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(confirmeMessage),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Le mot de passe doit etre long';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    labelText: "Mot de passe",
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        print(controller.text);
                        print(code);
                      }
                      final DataRes drSendCode = await UserRestApi()
                          .resetForgetPassword(email, code, controller.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(drSendCode.message)));
                    },
                    child: const Text('Confirmer')),
              ],
            ));
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
