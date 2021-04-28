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
    }).map((event) {
      return readAssetFileByStr(event);
    }).map((event) {
      event.then((value) {
        list.add(value);

        getCurrentBitmap(value.imgId).then((valueImage) {
          imageMap[value.imgId] = valueImage;
        }).whenComplete(() {
          //TODO   刷新次数过多
          setState(() {});
        });
      });
    }).listen((event) {}, onDone: () {
      // setState(() {});
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (detail) {
        _downX = detail.globalPosition.dx;
      },
      // onTapDown: (detail) {
      //   _downX = detail.globalPosition.dx;
      // },
      // onTapUp: (detail) {
      //   _upX = detail.globalPosition.dx;
      // },
      onHorizontalDragDown: (detail) {
        _downX = detail.globalPosition.dx;
        print("_downX---------------------$_downX");
      },
      onHorizontalDragUpdate: (detail){
        detail.globalPosition.dx;
      },
      onHorizontalDragCancel: (){

      },
      onHorizontalDragEnd: (detail) {
        ///TODO
        index++;
        if(index >= list.length){
          index = 0;
        }
        setState(() {});
        print("_downX---------------------$_upX");
      },
      onVerticalDragStart: (detail) {},
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
  Future<ui.Image> getCurrentBitmap(String imgId) async {
    ByteData data = await rootBundle.load("assets/images/3.0x/f$imgId.png");
    //TODO  Test
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: (targetScale * 750).round(),
        targetHeight: (targetScale * 400).round());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
