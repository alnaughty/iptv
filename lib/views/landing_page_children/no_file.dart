import 'package:flutter/material.dart';

class NoFilePage extends StatefulWidget {
  const NoFilePage({Key? key}) : super(key: key);

  @override
  State<NoFilePage> createState() => _NoFilePageState();
}

class _NoFilePageState extends State<NoFilePage> {
  late final FocusNode _focus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focus = FocusNode();
    _focus.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height - 90,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "logo-f",
              child: Image(
                width: size.width * .1,
                filterQuality: FilterQuality.high,
                image: const AssetImage("assets/images/logo.png"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Aucun fichier récupéré",
              style: TextStyle(
                color: Colors.white.withOpacity(1),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Veuillez télécharger un fichier m3u et profiter de l'application",
              style: TextStyle(
                color: Colors.white.withOpacity(.5),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              focusNode: _focus,
              onPressed: () async {
                await Navigator.pushNamed(context, '/auth_page');
              },
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Text(
                "Téléverser un fichier",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
