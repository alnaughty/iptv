import 'package:flutter/material.dart';
import 'package:vtv/data_component/main_data.dart';
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/models/series.dart';
import 'package:vtv/utils/drawer_player.dart';
import 'package:vtv/utils/drawer_view.dart';
import 'package:vtv/utils/movie_player.dart';
import 'package:vtv/views/landing_page_children/m3u_category_checker.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => MoviePageState();
}

class MoviePageState extends State<MoviePage> {
  final MainData _mainVm = MainData.instance;
  final GlobalKey<ScaffoldState> _kState = GlobalKey<ScaffoldState>();
  final GlobalKey<DrawerViewState> _kDrawer = GlobalKey<DrawerViewState>();
  Series? data;
  int currIndex = 0;
  DrawerPlayer? player;
  bool atBackDrawer = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      endDrawer: data == null
          ? null
          : data!.entries.length > 1
              ? DrawerView(
                  key: _kDrawer,
                  data: data!,
                )
              : null,
      body: StreamBuilder<List<M3UCategorized>>(
          stream: _mainVm.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Container();
            }
            final List<M3UCategorized> _data = snapshot.data!
                .where((element) => element.movies.isNotEmpty)
                .toList();
            return M3uCategorizedViewer(
              data: _data,
              type: 2,
              onPressed: (jsonData) async {
                print("MOVIE DATA : $jsonData");
                setState(() {
                  currIndex = 0;
                  data = Series.fromJson2(jsonData);
                  player = DrawerPlayer(
                    key: Key(data!.title),
                    link: data!.entries[currIndex].url!,
                    name: data!.title,
                    image: data!.entries[currIndex].image!,
                  );
                });
                if (data!.entries.length > 1) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  _kState.currentState!.openEndDrawer();
                } else {
                  if (data!.entries.isNotEmpty) {
                    /// SHOW VIDEO DIRECTLY!
                    print("PLAY DIRECTLY!");
                    await showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierLabel: "",
                      barrierColor: Colors.black.withOpacity(.6),
                      transitionBuilder: (_, a1, a2, c) => Transform.scale(
                        scale: a1.value,
                        child: Opacity(
                          opacity: a1.value,
                          child: Center(
                            child: Container(
                              width: size.width * .6,
                              color: Colors.black,
                              height: size.height * .8,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: MoviePlayer(
                                data: data!,
                              ),
                              // child: Column(
                              //   children: [
                              //     Expanded(
                              //       child: Container(
                              //         color: Colors.red,
                              //       ),
                              //     ),
                              //     Text(
                              //       data!.title,
                              //       style: const TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     )
                              //   ],
                              // ),
                            ),
                          ),
                        ),
                      ),
                      pageBuilder: (_, a1, a2) => Container(),
                    );
                  }
                }
              },
            );
          }),
    );
  }
}
