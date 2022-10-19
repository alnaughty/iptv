import 'package:flutter/material.dart';
import 'package:vtv/data_component/main_data.dart';
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/views/landing_page_children/m3u_category_checker.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  State<LivePage> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  final MainData _mainVm = MainData.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<M3UCategorized>>(
        stream: _mainVm.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Container();
          }
          final List<M3UCategorized> _data = snapshot.data!
              .where((element) => element.lives.isNotEmpty)
              .toList();

          return M3uCategorizedViewer(
            data: _data,
            type: 0,
            onPressed: (jsonData) {
              print("DATA : $jsonData");
            },
          );
        });
  }
}
