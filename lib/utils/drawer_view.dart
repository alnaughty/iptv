import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/models/series.dart';
import 'package:vtv/utils/drawer_player.dart';
import 'package:vtv/utils/image_handler.dart';

class DrawerView extends StatefulWidget {
  const DrawerView(
      {super.key, required this.data, this.customText = "Plus d'épisodes :"});
  final Series data;
  final String customText;
  @override
  State<DrawerView> createState() => DrawerViewState();
}

class DrawerViewState extends State<DrawerView> with ImageHandler {
  int currIndex = 0;
  DrawerPlayer? player;
  bool atBackDrawer = false;
  changeIndex(int x) {
    setState(() {
      currIndex = x;
    });
  }

  changePlayer(DrawerPlayer play) {
    setState(() {
      player = null;
      player = play;
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return LayoutBuilder(builder: (context, c) {
        final double w = c.maxWidth;
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(
              height: 15,
            ),
            player ?? Container(),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.data.entries[currIndex].name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: atBackDrawer ? Colors.white : Colors.grey.shade800,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: InkWell(
                onFocusChange: (bool r) {
                  setState(() {
                    atBackDrawer = r;
                  });
                },
                onTap: () => Navigator.of(context).pop(null),
                child: const Center(
                  child: Text(
                    "Retour",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.customText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: w,
              height: 150,
              child: ListView.separated(
                itemCount: widget.data.entries
                    .where((element) {
                      final int index = widget.data.entries.indexOf(element);
                      return index != currIndex;
                    })
                    .toList()
                    .length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final M3uParsedEntry value =
                      widget.data.entries.where((element) {
                    final int index = widget.data.entries.indexOf(element);
                    return index != currIndex;
                  }).toList()[i];
                  return GestureDetector(
                    onTap: () => setState(() {
                      currIndex = widget.data.entries.indexOf(value);
                      print("INDEX : $currIndex");
                      // currIndex = currIndex <= i ? currIndex + i : i;
                      player = DrawerPlayer(
                        key: Key(currIndex.toString()),
                        link: widget.data.entries[currIndex].url!,
                        name: widget.data.title,
                        image: widget.data.entries[currIndex].image!,
                      );
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 200,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: value.image == null
                                        ? noImage()
                                        : Image.network(
                                            value.image!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                        color: Colors.black.withOpacity(.5),
                                        child: Center(
                                          child: Icon(
                                            Icons.play_circle_outline_outlined,
                                            color: Colors.white.withOpacity(.8),
                                            size: 50,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          value.name,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, o) => const SizedBox(
                  width: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      });
    } catch (e) {
      return Center(
        child: LoadingAnimationWidget.halfTriangleDot(
            color: Colors.white, size: 60),
      );
    }
  }
}
