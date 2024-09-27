import '/app/core/exporter.dart';

class DraggableObjectModel {
  Offset position;
  double width;
  double height;
  String asset;
  Function(DraggableObjectModel value)? onTap;
  VoidCallback? onDoubleTap;

  DraggableObjectModel({
    required this.position,
    required this.width,
    required this.height,
    required this.asset,
    this.onTap,
    this.onDoubleTap,
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

  // copy with
  DraggableObjectModel copyWith({
    Offset? position,
    double? width,
    double? height,
    String? asset,
    Function(DraggableObjectModel value)? onTap,
    VoidCallback? onDoubleTap,
  }) {
    return DraggableObjectModel(
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
      asset: asset ?? this.asset,
      onTap: onTap ?? this.onTap,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
    );
  }
}
