import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "package:m3u_z_parser/src/models/m3u_entry.dart";
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/models/series.dart';
import 'package:vtv/services/lms_handler.dart';
import 'package:vtv/utils/image_handler.dart';

class M3uCategorizedViewer extends StatefulWidget {
  const M3uCategorizedViewer(
      {Key? key,
      required this.data,
      required this.type,
      required this.onPressed})
      : super(key: key);
  final List<M3UCategorized> data;
  final int type;
  final ValueChanged<Map<String, dynamic>> onPressed;
  @override
  State<M3uCategorizedViewer> createState() => _M3uCategorizedViewerState();
}

class Polydata {
  final Series? seriesValue;
  final M3uEntry? entryValue;
  const Polydata({this.seriesValue, this.entryValue});
  factory Polydata.fromSeries(Series serie) => Polydata(seriesValue: serie);
  factory Polydata.fromEntry(M3uEntry serie) => Polydata(entryValue: serie);
}

class _M3uCategorizedViewerState extends State<M3uCategorizedViewer>
    with ImageHandler {
  int currentCategoryIndex = 0;
  late final ScrollController _right;
  late final ScrollController _left;
  M3UCategorized? selectedCategory;
  late final int type = widget.type;
  List<Polydata> getData() {
    if (selectedCategory == null) return [];
    if (type <= 1) {
      return selectedCategory!.lives.map((e) => Polydata.fromEntry(e)).toList();
    } else {
      if (type == 2) {
        return selectedCategory!.movies
            .map((e) => Polydata.fromSeries(e))
            .toList();
      } else {
        return selectedCategory!.series
            .map((e) => Polydata.fromSeries(e))
            .toList();
      }
    }
  }

  late List<M3UCategorized> _displayData = [];

  List<Polydata> data = [];

  void search(String text) {
    setState(() {
      currentCategoryIndex = 0;
      _displayData = widget.data
          .where((element) => element.group.toLowerCase().contains(text))
          .toList();
      if (_displayData.isEmpty) {
        print("WARA");
        selectedCategory = null;
      } else {
        selectedCategory = _displayData[currentCategoryIndex];
        print("MAYDA");
        data = getData();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // changeSelected();
    search("");

    _right = ScrollController();
    _left = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _right.dispose();
    _left.dispose();
    super.dispose();
  }

  Widget imageBuilder(String url, double width, double height,
          [bool entry = false]) =>
      Expanded(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          fit: entry ? BoxFit.contain : BoxFit.cover,
          width: width,
          height: height,
          // alignment: Alignment.topCenter,
          errorBuilder: (_, o, trace) => noImage(),
          loadingBuilder: (_, c, chunk) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: chunk != null
                  ? Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.halfTriangleDot(
                              color: Colors.white,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                    )
                  : c,
            );
          },
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.data.isEmpty
          ? const Center(
              child: Text(
                "Pas de données disponibles",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            )
          : Row(
              children: [
                Container(
                  width: 200,
                  color: Colors.black,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          onChanged: (text) {
                            search(text);
                          },
                          onSubmitted: (text) {
                            search(text);
                          },
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Rechercher",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: _displayData.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    "Pas des données disponibles",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(.6)),
                                  ),
                                ),
                              )
                            : Scrollbar(
                                controller: _right,
                                child: ListView(
                                  controller: _right,
                                  children: [
                                    ..._displayData.map((e) {
                                      final int i = _displayData.indexOf(e);
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          currentCategoryIndex = i;
                                          selectedCategory = _displayData[
                                              currentCategoryIndex];
                                          data = getData();
                                        }),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 15),
                                          color: currentCategoryIndex == i
                                              ? Colors.white
                                              : Colors.transparent,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  e.group,
                                                  style: TextStyle(
                                                    color:
                                                        currentCategoryIndex ==
                                                                i
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${type <= 1 ? e.lives.length : type == 2 ? e.movies.length : e.series.length}",
                                                style: TextStyle(
                                                  color:
                                                      (currentCategoryIndex == i
                                                              ? Colors.black
                                                              : Colors.white)
                                                          .withOpacity(.5),
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (_, c) {
                    final double w = c.maxWidth;
                    final double h = c.maxHeight;
                    return data.isEmpty
                        ? Container()
                        : Scrollbar(
                            controller: _left,
                            child: GridView.count(
                              controller: _left,
                              padding: const EdgeInsets.all(15),
                              crossAxisCount: w ~/ 140,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: type <= 1 ? .9 : .6,
                              children: [
                                ...(data).map(
                                  (e) => LayoutBuilder(builder: (context, cc) {
                                    final double ww = cc.maxWidth;
                                    final double hh = cc.maxHeight;
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (type <= 1) {
                                            widget.onPressed(
                                                e.entryValue!.toJson());
                                          } else {
                                            widget.onPressed(
                                                e.seriesValue!.toJson());
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            if (e.entryValue == null) ...{
                                              /// SERIES
                                              if (e.seriesValue!.entries[0]
                                                      .image !=
                                                  null) ...{
                                                imageBuilder(
                                                  e.seriesValue!.entries[0]
                                                      .image!,
                                                  ww,
                                                  hh,
                                                ),
                                              } else ...{
                                                Expanded(
                                                  child: noImage(),
                                                )
                                              },
                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Text(
                                                e.seriesValue!.title,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              )
                                            } else ...{
                                              /// M3uEntry
                                              if (e.entryValue!
                                                      .attributes['tvg-logo'] !=
                                                  null) ...{
                                                imageBuilder(
                                                    e.entryValue!.attributes[
                                                        'tvg-logo']!,
                                                    ww,
                                                    hh,
                                                    true),
                                              } else ...{
                                                Expanded(
                                                  child: noImage(),
                                                )
                                              },
                                              const SizedBox(
                                                height: 10,
                                              ),

                                              Text(
                                                e.entryValue!.title,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              )
                                            }
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                  }),
                ),
              ],
            ),
    );
  }
}
