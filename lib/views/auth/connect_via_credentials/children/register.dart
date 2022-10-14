import 'package:flutter/material.dart';
import 'package:vtv/utils/extensions/string.dart';

class CredentialRegister extends StatefulWidget {
  const CredentialRegister({Key? key}) : super(key: key);

  @override
  State<CredentialRegister> createState() => CredentialRegisterState();
}

class CredentialRegisterState extends State<CredentialRegister> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _m3u;
  String get m3u => _m3u.text;
  String get email => _email.text;
  String get password => _password.text;

  bool _isObscured = true;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _m3u = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _m3u.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool get isValidated => _k.currentState?.validate() ?? false;
  final GlobalKey<FormState> _k = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _k,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email".toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _email,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Default",
              ),
              onChanged: (text) {
                _k.currentState!.validate();
                print(text);
              },
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.white,
              validator: (String? text) {
                if (text == null) {
                  return "Entrée invalide";
                } else if (text.isEmpty) {
                  return "Ce champ est requis";
                } else if (!text.isEmail) {
                  return "Pas un e-mail valide";
                }
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "sample@email.com".toUpperCase(),
                // labelText: ,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Mot de passe".toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _password,
              obscureText: _isObscured,
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Default",
              ),
              validator: (String? text) {
                if (text!.isEmpty) {
                  return "This field is required";
                }
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "******".toUpperCase(),
                // labelText: ,
                alignLabelWithHint: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  padding: const EdgeInsets.only(right: 20),
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "M3U URL".toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _m3u,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Default",
              ),
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.white,
              validator: (String? text) {
                if (text == null) {
                  return "Entrée invalide";
                } else if (text.isEmpty) {
                  return "Ce champ est requis";
                }
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "http(s)://mym3u.url".toUpperCase(),
                // labelText: ,
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
