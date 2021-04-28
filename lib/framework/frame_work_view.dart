import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frame_work/framework/bean/frame_work_bean.dart';

class FrameWorkView extends CustomPainter {
  //TODO
  double targetScale = 360.0 / 750.0;
  Size size;

  BuildContext context;
  List<FrameWorkBean> list;
  Map<String, ui.Image> imageMap;
  int index = 0;

  Paint _paint;

  //原图大小
  double originalWidth = 750.0, originalHeight = 400.0;

  //每个点的x轴，y轴的偏移量
  double offsetX, offsetY;

  //平均宽度，用于控制手势旋转
  double avgWidth;

  FrameWorkView(BuildContext context, List<FrameWorkBean> list,
      Map<String, ui.Image> imageMap,int index) {
    this.context = context;
    this.list = list;
    this.imageMap = imageMap;
    this.index = index;
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
    this.size = size;
    if (list != null &&
        imageMap != null &&
        list.isNotEmpty &&
        imageMap.isNotEmpty &&
        index < list.length) {
      FrameWorkBean frameWorkBean = list[index];

      imageMap[frameWorkBean.imgId].height;
      imageMap[frameWorkBean.imgId].width;

      canvas.drawImage(imageMap[frameWorkBean.imgId], Offset(0.0, 0.0), _paint);

      drawPoints(canvas, frameWorkBean.points);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawPoints(Canvas canvas, List<FrameWorkBeanPoint> points) {
    if (points != null && points.isNotEmpty) {
      FrameWorkBeanPoint point;
      for (var i = 0; i < points.length; i++) {
        point = points[i];
        canvas.drawCircle(
            Offset(computeX(point.x), computeY(point.y)), 3, _paint);
      }
    }
  }

  //TODO   偏移有问题
  double computeX(int x) {
    return targetScale * x + size.width/52.0;
  }
//TODO   偏移有问题
  double computeY(int y) {
    return targetScale * y+ size.height/52.0;
  }
}
