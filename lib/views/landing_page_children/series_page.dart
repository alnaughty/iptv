import 'package:flutter/material.dart';
import 'package:vtv/data_component/main_data.dart';
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/utils/drawer_player.dart';
import 'package:vtv/utils/drawer_view.dart';
import 'package:vtv/utils/global.dart';
import 'package:vtv/utils/image_handler.dart';
import 'package:vtv/utils/player.dart';
import 'package:vtv/views/landing_page_children/m3u_category_checker.dart';

import '../../models/series.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => SeriesPageState();
}

class SeriesPageState extends State<SeriesPage> with ImageHandler {
  final MainData _mainVm = MainData.instance;
  final GlobalKey<ScaffoldState> _kState = GlobalKey<ScaffoldState>();
  final GlobalKey<DrawerViewState> _drawer = GlobalKey<DrawerViewState>();
  Series? data;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _kState,
      backgroundColor: Colors.transparent,
      endDrawer: data == null
          ? null
          : Container(
              width: size.width * .4,
              height: size.height,
              color: Colors.black,
              child: data != null && data!.entries.isNotEmpty
                  ? DrawerView(key: _drawer, data: data!)
                  : Container()),
      body: StreamBuilder<List<M3UCategorized>>(
          stream: _mainVm.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Container();
            }
            final List<M3UCategorized> _data = snapshot.data!
                .where((element) => element.series.isNotEmpty)
                .toList();
            return M3uCategorizedViewer(
              data: _data,
              type: 3,
              onPressed: (jsonData) async {
                print("SERIES DATA : $jsonData");
                setState(() {
                  data = Series.fromJson2(jsonData);
                });
                await Future.delayed(const Duration(milliseconds: 100));
                _kState.currentState!.openEndDrawer();
                await Future.delayed(const Duration(milliseconds: 100));
                _drawer.currentState!.changeIndex(0);
                _drawer.currentState!.changePlayer(DrawerPlayer(
                  key: const Key("0"),
                  link: data!.entries[0].url!,
                  name: data!.title,
                  image: data!.entries[0].image!,
                ));
              },
            );
          }),
    );
  }
}
