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
    }).listen((event) {
      event.then((value) {
        list.add(value);
      });
    }, onDone: () {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
      size: Size(500, 300),
      painter: FrameWorkView(context, list),
    ));
  }

  ///读取Assets下的文件中的内容 to String
  Future<FrameWorkBean> readAssetFileByStr(String event) async {
    String jsonData = await rootBundle.loadString(event);
    final jsonResult = json.decode(jsonData);
    return new FrameWorkBean().fromJson(jsonResult);
  }

  /// 通过assets路径，获取资源图片
  Future<ui.Image> getCurrentBitmap(String imgId) async {
    ByteData data = await rootBundle.load("assets/images/3.0x/$imgId.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
