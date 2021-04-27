import 'package:flutter_frame_work/generated/json/base/json_convert_content.dart';

class FrameWorkBean with JsonConvert<FrameWorkBean> {
  String imgId;
  List<FrameWorkBeanPoint> points;
}

class FrameWorkBeanPoint with JsonConvert<FrameWorkBeanPoint> {
  int id;
  String name;
  int x;
  int y;
}
