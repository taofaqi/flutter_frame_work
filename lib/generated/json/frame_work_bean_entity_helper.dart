import 'package:flutter_frame_work/framework/bean/frame_work_bean.dart';

frameWorkBeanEntityFromJson(FrameWorkBean data, Map<String, dynamic> json) {
	if (json['imgId'] != null) {
		data.imgId = json['imgId'].toString();
	}
	if (json['points'] != null) {
		data.points = new List<FrameWorkBeanPoint>();
		(json['points'] as List).forEach((v) {
			data.points.add(new FrameWorkBeanPoint().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> frameWorkBeanEntityToJson(FrameWorkBean entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['imgId'] = entity.imgId;
	if (entity.points != null) {
		data['points'] =  entity.points.map((v) => v.toJson()).toList();
	}
	return data;
}

frameWorkBeanPointFromJson(FrameWorkBeanPoint data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['x'] != null) {
		data.x = json['x'] is String
				? int.tryParse(json['x'])
				: json['x'].toInt();
	}
	if (json['y'] != null) {
		data.y = json['y'] is String
				? int.tryParse(json['y'])
				: json['y'].toInt();
	}
	return data;
}

Map<String, dynamic> frameWorkBeanPointToJson(FrameWorkBeanPoint entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['x'] = entity.x;
	data['y'] = entity.y;
	return data;
}