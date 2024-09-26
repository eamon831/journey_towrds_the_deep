import '/app/core/exporter.dart';

class DraggableObjectModel {
  Offset position;
  double width;
  double height;
  String asset;

  DraggableObjectModel({
    required this.position,
    required this.width,
    required this.height,
    required this.asset,
  });

  factory DraggableObjectModel.fromJson(Map<String, dynamic> json) {
    return DraggableObjectModel(
      position: Offset(json['dx'], json['dy']),
      width: json['width'],
      height: json['height'],
      asset: json['asset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dx': position.dx,
      'dy': position.dy,
      'width': width,
      'height': height,
      'asset': asset,
    };
  }
}
