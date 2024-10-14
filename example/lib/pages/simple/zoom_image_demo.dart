import 'dart:math';

import 'package:example/main.dart';
import 'package:extended_image/extended_image.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:flutter/material.dart';

@FFRoute(
  name: 'fluttercandies://zoomimage',
  routeName: 'ImageZoom',
  description: 'Zoom and Pan.',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 4,
  },
)
class ZoomImageDemo extends StatelessWidget {
  // you can handle gesture detail by yourself with key
  final GlobalKey<ExtendedImageGestureState> gestureKey = GlobalKey<ExtendedImageGestureState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('zoom/pan image demo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              gestureKey.currentState!.reset();
              //you can also change zoom manual
              //gestureKey.currentState.gestureDetails=GestureDetails();
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: 300,
        height: 300,
        margin: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(color: Theme.of(context).highlightColor),
        clipBehavior: Clip.antiAlias,
        child: ExtendedImage.asset(
          'assets/test_image.png',
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          extendedImageGestureKey: gestureKey,
          initGestureConfigHandler: (ExtendedImageState state) {
            return GestureConfig(
              minScale: 0.8,
              animationMinScale: 0.7,
              maxScale: 4.0,
              animationMaxScale: 4.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 0.9,
              inPageView: false,
              initialAlignment: InitialAlignment.centerLeft,
              reverseMousePointerScrollDirection: true,
              gestureDetailsIsChanged: (GestureDetails? details) {
                //print(details?.totalScale);
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...['+', '-'].map((String e) {
            return FloatingActionButton(
              mini: true,
              heroTag: e,
              onPressed: () {
                var details = gestureKey.currentState!.gestureDetails;
                var totalScale = details?.totalScale ?? 0;
                totalScale += (e == '+' ? 0.05 : -0.05);
                totalScale = max(0.1, totalScale);
                gestureKey.currentState!.gestureDetails = GestureDetails(
                  totalScale: totalScale,
                  offset: details?.offset,
                );
              },
              child: Text(e, style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)),
            );
          }),
          ...['←', '→', '↑', '↓'].map((String e) {
            return FloatingActionButton(
              mini: true,
              heroTag: e,
              onPressed: () {
                var details = gestureKey.currentState!.gestureDetails;

                var offset = details?.offset ?? Offset.zero;
                if(e == '↑' || e == '↓') {
                  offset = offset.translate(0, e == '↑' ? -10 : 10);
                }else{
                  offset = offset.translate(e == '←' ? -10 : 10, 0);
                }

                gestureKey.currentState!.gestureDetails = GestureDetails(
                  totalScale: details?.totalScale,
                  offset: offset,
                );
              },
              child: Text(e, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            );
          }),
        ],
      ),
    );
  }
}
