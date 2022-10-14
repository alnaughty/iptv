import 'package:flutter/material.dart';
import 'package:vtv/core/auth_assets/auth_assets.dart';
import 'package:vtv/utils/palette.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with AuthAssets, Palette {
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: background,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          children: [
            const SafeArea(
              child: SizedBox(
                height: 20,
              ),
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
            const Align(
              alignment: Alignment.center,
              child: Text(
                "CONNECTE-TOI AVEC NOUS !",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * .15,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          currentFocus == i ? Colors.white : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  focusNode: nodes[i],
                  onFocusChange: (bool f) {
                    setState(() {
                      currentFocus = i;
                    });
                  },
                  onTap: () async {
                    await Navigator.pushNamed(context, pages[i]);
                  },
                  child: SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        buttons[i],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (_, i) => Divider(
                color: Colors.white.withOpacity(.5),
              ),
              itemCount: buttons.length,
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [

            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
