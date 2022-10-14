import 'package:flutter/material.dart';
import 'package:vtv/utils/palette.dart';

class ConnectViaM3U extends StatefulWidget {
  const ConnectViaM3U({Key? key}) : super(key: key);

  @override
  State<ConnectViaM3U> createState() => _ConnectViaM3UState();
}

class _ConnectViaM3UState extends State<ConnectViaM3U> with Palette {
  late final FocusNode iconButtonNode;
  @override
  void initState() {
    iconButtonNode = FocusNode(debugLabel: "back-button");
    iconButtonNode.requestFocus();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    iconButtonNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: background,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  IconButton(
                    focusNode: iconButtonNode,
                    onPressed: () => Navigator.of(context).pop(),
                    padding: const EdgeInsets.all(0),
                    icon: Image.asset(
                      "assets/icons/back.png",
                      color: Colors.white,
                      height: 30,
                    ),
                  ),
                  const Spacer(),
                  Hero(
                    tag: "logo-f",
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
