import 'package:flutter/material.dart';
import 'package:vtv/utils/image_handler.dart';
import 'package:vtv/utils/player.dart';

class DrawerPlayer extends StatefulWidget {
  const DrawerPlayer(
      {super.key, required this.link, required this.name, this.image});
  final String link;
  final String name;
  final String? image;
  @override
  State<DrawerPlayer> createState() => _DrawerPlayerState();
}

class _DrawerPlayerState extends State<DrawerPlayer> with ImageHandler {
  bool play = false;
  final FocusNode _fNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    _fNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final double w = c.maxWidth;
      return Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: play
                ? CustomPlayer(
                    link: widget.link,
                    id: "id",
                    name: widget.name,
                    image: widget.image ?? "",
                    popOnError: false)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: w,
                      height: w * .6,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: widget.image == null
                                ? noImage()
                                : Image.network(
                                    widget.image!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                          Positioned.fill(
                            child: InkWell(
                              onTap: () {
                                print("ASDAS");
                                setState(() {
                                  play = !play;
                                });
                              },
                              focusNode: _fNode,
                              focusColor: Colors.white,
                              splashColor: Colors.grey,
                              splashFactory: InkRipple.splashFactory,
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_outline_outlined,
                                  color: Colors.white.withOpacity(.8),
                                  size: 50,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      );
    });
  }
}
