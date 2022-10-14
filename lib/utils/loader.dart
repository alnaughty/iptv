import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderV {
  Widget loading({
    String? text,
    required Color color,
  }) {
    return Container(
      color: Colors.black.withOpacity(.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.halfTriangleDot(
            color: color,
            size: 60,
          ),
          if (text != null) ...{
            const SizedBox(
              height: 20,
            ),
            Material(
              color: Colors.transparent,
              elevation: 0,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            )
          },
        ],
      ),
    );
  }
}
