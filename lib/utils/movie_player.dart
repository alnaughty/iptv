import 'package:flutter/material.dart';
import 'package:vtv/models/series.dart';
import 'package:vtv/utils/player.dart';

class MoviePlayer extends StatefulWidget {
  const MoviePlayer({super.key, required this.data});
  final Series data;
  @override
  State<MoviePlayer> createState() => _MoviePlayerState();
}

class _MoviePlayerState extends State<MoviePlayer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final double w = c.maxWidth;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // Navigator.of(context).pop(null);
                  },
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (_, c) {
                  final double h = c.maxHeight;
                  final double w = c.maxWidth;
                  return SizedBox(
                    height: h,
                    width: h * 1.6,
                    child: CustomPlayer(
                      link: widget.data.entries[0].url!,
                      id: "id",
                      name: widget.data.entries[0].name,
                      image: widget.data.entries[0].image ?? "",
                      popOnError: true,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.data.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      );
      // return Center(
      //   child: Container(
      //     width: w,
      //     color: Colors.black,
      //     height: size.height * .8,
      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      //     child: ,
      //   ),
      // );
    });
  }
}
