import 'package:flutter/material.dart';
import 'package:vtv/core/controller/landing_controller.dart';
import 'package:vtv/core/landing_assets/landing_assets.dart';
import 'package:vtv/services/data_handler.dart';
import 'package:vtv/utils/extensions/string.dart';
import 'package:vtv/utils/global.dart';
import 'package:vtv/utils/palette.dart';
import 'package:vtv/views/landing_page_children/no_file.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage>
    with Palette, LandingAssets, SingleTickerProviderStateMixin {
  static final LandingController _controller = LandingController.instance;
  static final DatabaseHandler _db = DatabaseHandler.instance;

  late final TabController _tabController;
  checkData() async {
    await _db.joinedData.then((value) {
      print(value);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      userId = cacher.uid;
    });
    if (userId != null) {
      checkData();
    }
    _tabController = TabController(vsync: this, length: tabs.length);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await Future.delayed(switcherDuration);
    //   for (Widget child in tabContents) {
    //     setState(() {
    //       heights.add(
    //           keys[_controller.currentIndex].currentContext?.size?.height ??
    //               0.0);
    //     });
    //   }
    //   print("HEIGHTS DATA : $heights");
    // });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appmaincolor,
      body: Container(
        width: double.maxFinite,
        height: size.height,
        decoration: BoxDecoration(
          gradient: background,
        ),
        child: SafeArea(
          child: userId == null
              ? const NoFilePage()
              : CustomScrollView(
                  slivers: [
                    // Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 20,
                    //       vertical: 10,
                    //     ),
                    //     child: Row(
                    //       children: [
                    // const Hero(
                    //   tag: "logo-f",
                    //   child: Image(
                    //     width: 60,
                    //     filterQuality: FilterQuality.high,
                    //     image: AssetImage("assets/images/logo.png"),
                    //   ),
                    // ),
                    //         const Spacer(),
                    //         Container(
                    //           padding: const EdgeInsets.symmetric(
                    //             vertical: 5,
                    //             horizontal: 5,
                    //           ),
                    //           height: 40,
                    //           // width: w * .4,
                    //           decoration: BoxDecoration(
                    //             color: Colors.black.withOpacity(.3),
                    //             borderRadius: BorderRadius.circular(
                    //               100,
                    //             ),
                    //           ),
                    //           alignment: Alignment.center,
                    //           child: Row(
                    //             children: [
                    //               ListView.separated(
                    //                 shrinkWrap: true,
                    //                 scrollDirection: Axis.horizontal,
                    // itemBuilder: (_, index) => InkWell(
                    //   focusColor: Colors.white,
                    //   autofocus: true,
                    //   focusNode: focusNodes[_controller.currentIndex],
                    //   onFocusChange: (bool f) {
                    //     // if (f) {
                    //     //   print("FOCUS SA ${tabs[index]}");
                    //     //   _vm.update(index);
                    //     //   _controller.index = index;
                    //     // }
                    //     focusNodes[_controller.currentIndex]
                    //         .requestFocus();
                    //     setState(() {
                    //       _controller.currentIndex = index;
                    //     });
                    //   },
                    //   onTap: () {
                    //     setState(() {
                    //       _controller.currentIndex = index;
                    //     });
                    //     // _vm.update(index);
                    //     // _controller.index = index;
                    //   },
                    //   child: AnimatedContainer(
                    //     duration: const Duration(
                    //       milliseconds: 700,
                    //     ),
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 20,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: index == _controller.currentIndex
                    //           ? Colors.white24
                    //           : Colors.transparent,
                    //       borderRadius: BorderRadius.circular(
                    //         100,
                    //       ),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         tabs[index],
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           // fontSize: 16,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //                 separatorBuilder: (_, x) => const SizedBox(
                    //                   width: 10,
                    //                 ),
                    //                 itemCount: tabs.length,
                    //               ),
                    //               const SizedBox(
                    //                 width: 10,
                    //               ),
                    // PopupMenuButton<int>(
                    //   onSelected: (int i) async {
                    //     // await Navigator.pushNamed(
                    //     //   context,
                    //     //   i == 0 ? "/favorite_page" : "/auth_page",
                    //     // );
                    //   },
                    //   padding: const EdgeInsets.all(0),
                    //   color: dark,
                    //   icon: const Icon(
                    //     Icons.more_horiz_rounded,
                    //     color: Colors.white,
                    //   ),
                    //   offset: const Offset(0, 30),
                    //   itemBuilder: (_) => [
                    //     if (userId != null) ...{
                    //       PopupMenuItem<int>(
                    //         value: 0,
                    //         child: itemContainer(
                    //           const Icon(
                    //             Icons.favorite,
                    //             color: Colors.white,
                    //             size: 20,
                    //           ),
                    //           "Favoris",
                    //         ),
                    //       ),
                    //       PopupMenuItem<int>(
                    //         value: 3,
                    //         child: itemContainer(
                    //           const Icon(
                    //             Icons.history,
                    //             color: Colors.white,
                    //             size: 20,
                    //           ),
                    //           "Historique",
                    //         ),
                    //       ),
                    //     },
                    //     PopupMenuItem<int>(
                    //       value: 1,
                    //       child: itemContainer(
                    //         const Icon(
                    //           Icons.settings,
                    //           color: Colors.white,
                    //           size: 20,
                    //         ),
                    //         "Réglages",
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    SliverAppBar(
                      floating: true,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 60,
                      // pinned: true,
                      leading: const SafeArea(
                        child: Hero(
                          tag: "logo-f",
                          child: Image(
                            width: 60,
                            filterQuality: FilterQuality.high,
                            image: AssetImage("assets/images/logo.png"),
                          ),
                        ),
                      ),
                      actions: [
                        ...tabs.map(
                          (e) {
                            final int index = tabs.indexOf(e);
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                  focusColor: Colors.white,
                                  focusNode:
                                      focusNodes[_controller.currentIndex],
                                  onFocusChange: (bool f) {
                                    // if (f) {
                                    //   print("FOCUS SA ${tabs[index]}");
                                    //   _vm.update(index);
                                    //   _controller.index = index;
                                    // }
                                    focusNodes[_controller.currentIndex]
                                        .requestFocus();
                                    setState(() {
                                      _controller.currentIndex = index;
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      _controller.currentIndex = index;
                                    });
                                    // _vm.update(index);
                                    // _controller.index = index;
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 700,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index == _controller.currentIndex
                                          ? Colors.white24
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        100,
                                      ),
                                    ),
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        tabs[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          // fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        PopupMenuButton<int>(
                          onSelected: (int i) async {
                            await Navigator.pushNamed(
                              context,
                              i == 0
                                  ? "/favorite_page"
                                  : i == 1
                                      ? "/auth_page"
                                      : "/history_page",
                            );
                            // await Navigator.pushNamed(
                            //   context,
                            //   i == 0 ? "/favorite_page" : "/auth_page",
                            // );
                          },
                          padding: const EdgeInsets.all(0),
                          color: dark,
                          icon: const Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                          ),
                          offset: const Offset(0, 30),
                          itemBuilder: (_) => [
                            if (userId != null) ...{
                              PopupMenuItem<int>(
                                value: 0,
                                child: itemContainer(
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  "Favoris",
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 3,
                                child: itemContainer(
                                  const Icon(
                                    Icons.history,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  "Historique",
                                ),
                              ),
                            },
                            PopupMenuItem<int>(
                              value: 1,
                              child: itemContainer(
                                const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                "Réglages",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          AnimatedSwitcher(
                            duration: switcherDuration,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: tabContents[_controller.currentIndex],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
          // child: SingleChildScrollView(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: Column(
          //     children: [

          //       /// BODY VIEW
          // AnimatedSwitcher(
          //   duration: switcherDuration,
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: tabContents[_controller.currentIndex],
          //   ),
          //   // child: heights.isEmpty
          //   //     ? Container()
          //   //     : AnimatedContainer(
          //   //         duration: switcherDuration,
          //   //         height: heights[_controller.currentIndex],
          //   //         child: TabBarView(
          //   //           controller: _tabController,
          //   //           children: tabContents
          //   //               .map(
          //   //                 (e) => TabContent(
          //   //                   child: e,
          //   //                 ),
          //   //               )
          //   //               .toList(),
          //   //         ),
          //   //       ),
          // )
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
