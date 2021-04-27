import 'dart:convert';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frame_work/framework/bean/frame_work_bean.dart';

class FrameWorkView extends CustomPainter {
  BuildContext context;
  List<FrameWorkBean> list;
  int index = 0;

  Paint _paint;

  //原图大小
  double originalWidth = 750.0, originalHeight = 400.0;

  //每个点的x轴，y轴的偏移量
  double offsetX, offsetY;

  //平均宽度，用于控制手势旋转
  double avgWidth;

  FrameWorkView(BuildContext context, List<FrameWorkBean> list) {
    this.context = context;
    this.list = list;
    createPaint();
  }

  void createPaint() {
    _paint = Paint();
    _paint.color = Colors.red;
    _paint.isAntiAlias = true;

//TODO  缺少animator
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (list != null && list.isNotEmpty && index < list.length) {
      FrameWorkBean frameWorkBean = list[index];
      canvas.drawCircle(Offset(200.0, 200.0), 10, _paint);
      getCurrentBitmap(frameWorkBean.imgId).then((value) {
        canvas.drawImage(value, Offset(200.0, 200.0), _paint);
      });
      drawPoints(canvas, frameWorkBean.points);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 通过assets路径，获取资源图片
  Future<ui.Image> getCurrentBitmap(String imgId) async {
    ByteData data = await rootBundle.load("assets/images/3.0x/$imgId.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  void drawPoints(Canvas canvas, List<FrameWorkBeanPoint> points) {
    if (points != null && points.isNotEmpty) {
      for (var i = 0; i < points.length; i++) {
        // canvas.drawCircle(c, radius, paint)

      }
    }
  }
}
