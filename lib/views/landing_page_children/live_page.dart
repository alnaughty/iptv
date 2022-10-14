import 'package:flutter/material.dart';
import 'package:vtv/utils/global.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  State<LivePage> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Container(
            width: 200,
            color: Colors.black,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => Text(
                i.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              separatorBuilder: (_, i) => const SizedBox(
                height: 10,
              ),
              itemCount: 100,
            ),
          ),
          Expanded(
            child: Column(),
          )
        ],
      ),
    );
  }
}
