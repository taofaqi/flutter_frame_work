import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frame_work/framework/frame_work_view.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui;

import 'bean/frame_work_bean.dart';

class FrameWorkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FrameWorkState();
  }
}

class FrameWorkState extends State<FrameWorkPage> {
  List<FrameWorkBean> list;
  Map<String, ui.Image> imageMap = Map<String, ui.Image>();
  double targetScale = 360.0 / 750.0;

  double _downX, _upX;
  bool isDrag = false;
  int index = 0;

  double dragWidth = 10.0;

  @override
  void initState() {
    list = <FrameWorkBean>[];
    super.initState();
    Rx.fromCallable(() =>
            DefaultAssetBundle.of(context).loadString('AssetManifest.json'))
        .flatMap((event) {
      final Iterable fileNameList = json
          .decode(event)
          .keys
          .where(((String key) => key.startsWith('assets/framework')));
      return Stream<String>.fromIterable(fileNameList);
    }).flatMap((event) {
      return Rx.fromCallable(() => readAssetFileByStr(event));
    }).flatMap((event) {
      list.add(event);
      return Rx.fromCallable(() => getCurrentBitmap(event.imgId));
    }).listen((event) {
      print("listen");
    }, onDone: () {
      print("onDone");
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (detail) {
        _downX = detail.globalPosition.dx;
      },
      onTapUp: (detail) {
        _upX = detail.globalPosition.dx;
      },
      onPanDown: (DragDownDetails e) {},
      onPanUpdate: (DragUpdateDetails e) {},
      onPanEnd: (DragEndDetails e) {},
      onHorizontalDragDown: (detail) {
        _downX = detail.globalPosition.dx;
        print("_downX---------------------$_downX");
      },
      onHorizontalDragUpdate: (detail) {
        if (_downX - detail.globalPosition.dx > 0) {
          index++;
          if (index == list.length - 1) {
            index = 0;
          }
        } else {
          index--;
          if (index < 0) {
            index = list.length - 1;
          }
        }
        setState(() {});
        print(
            "detail.globalPosition.dx---------------------${detail.globalPosition.dx}");
      },
      onHorizontalDragEnd: (detail) {
        ///TODO

        print("_downX---------------------$_upX");
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        painter: FrameWorkView(context, list, imageMap, index),
      ),
    );
  }

  ///读取Assets下的文件中的内容 to String
  Future<FrameWorkBean> readAssetFileByStr(String event) async {
    String jsonData = await rootBundle.loadString(event);
    final jsonResult = json.decode(jsonData);
    return new FrameWorkBean().fromJson(jsonResult);
  }

  /// 通过assets路径，获取资源图片
  Future<void> getCurrentBitmap(String imgId) async {
    ByteData data = await rootBundle.load("assets/images/3.0x/f$imgId.png");
    //TODO  Test
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: (targetScale * 750).round(),
        targetHeight: (targetScale * 400).round());
    ui.FrameInfo fi = await codec.getNextFrame();
    imageMap[imgId] = fi.image;
  }
}
