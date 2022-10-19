import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  bool _isFetching = true;
  checkData() async {
    setState(() {
      _isFetching = true;
    });
    await _db.categorizeData();
    setState(() {
      _isFetching = false;
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appmaincolor,
        body: Container(
          width: double.maxFinite,
          height: size.height,
          decoration: BoxDecoration(
            gradient: background,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const SafeArea(
                        child: Hero(
                          tag: "logo-f",
                          child: Image(
                            width: 60,
                            filterQuality: FilterQuality.high,
                            image: AssetImage("assets/images/logo.png"),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        height: 40,
                        // width: w * .4,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.3),
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) => InkWell(
                                focusColor: Colors.white,
                                autofocus: true,
                                focusNode: FocusNode(
                                  debugLabel: tabs[index],
                                ),
                                onFocusChange: (bool f) {
                                  if (f) {
                                    print("FOCUS SA ${tabs[index]}");
                                    // vm.update(index);
                                    // _controller.index = index;
                                  }
                                },
                                onTap: () {
                                  // _vm.update(index);
                                  // _controller.index = index;
                                  _controller.currentIndex = index;
                                  _tabController.index = index;
                                  setState(() {});
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
                              separatorBuilder: (_, x) => const SizedBox(
                                width: 10,
                              ),
                              itemCount: tabs.length,
                            ),
                            const SizedBox(
                              width: 10,
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
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: userId == null
                      ? const NoFilePage()
                      : _isFetching
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingAnimationWidget.halfTriangleDot(
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "Récupération de données",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: tabContents,
                            ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
