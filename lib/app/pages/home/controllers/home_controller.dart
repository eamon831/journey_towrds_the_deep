import 'dart:math';

import '/app/entity/draggable_object.dart';

import '/app/core/exporter.dart';

class HomeController extends BaseController {
  final isDragging = false.obs;
  final methaneCount = 0.0.obs;

  bool checkCollision(Offset position1, Offset position2, double size) {
    final bool collision = distanceBetweenPoints(position1, position2) < size;
    if (collision) {
      if (kDebugMode) {
        print('Collision between $position1 and $position2');
      }
    }
    return collision;
  }

  double distanceBetweenPoints(Offset point1, Offset point2) {
    return sqrt(pow(point1.dx - point2.dx, 2) + pow(point1.dy - point2.dy, 2));
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
