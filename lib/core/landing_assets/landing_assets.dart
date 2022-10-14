import 'package:flutter/material.dart';
import 'package:vtv/views/landing_page_children/live_page.dart';

class LandingAssets {
  final Duration switcherDuration = const Duration(milliseconds: 500);
  final List<String> tabs = const [
    "En Direct",
    "Films",
    "Séries",
    "Instruction"
  ];
  // late final List<GlobalKey<dynamic>> keys = [
  //   _kLive,
  //   _kFilms,
  //   _kSeries,
  //   _kInstruction,
  // ];
  // List<double> heights = [];

  late final List<FocusNode> focusNodes = tabs
      .map(
        (e) => FocusNode(
          debugLabel: e,
        ),
      )
      .toList();
  final GlobalKey<LivePageState> _kLive = GlobalKey<LivePageState>();
  final GlobalKey _kFilms = GlobalKey();
  final GlobalKey _kSeries = GlobalKey();
  final GlobalKey _kInstruction = GlobalKey();

  late final List<Widget> tabContents = [
    LivePage(
      key: _kLive,
    ),
    Container(
      key: _kFilms,
      height: 600,
      width: double.infinity,
      color: Colors.blue,
    ),
    Container(
      key: _kSeries,
      height: 900,
      width: double.infinity,
      color: Colors.green,
    ),
    Container(
      key: _kInstruction,
      height: 500,
      width: double.infinity,
      color: Colors.yellow,
    ),
  ];
  Widget itemContainer(Widget icon, String label) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
}

class TabContent extends StatefulWidget {
  final Widget child;

  const TabContent({Key? key, required this.child})
      : super(key: key); // <<<=== key added

  @override
  // ignore: library_private_types_in_public_api
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin<TabContent> {
  @override
  bool get wantKeepAlive => true;

  late final Widget child;

  @override
  void initState() {
    super.initState();
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
