import 'dart:math';

import 'package:getx_template/app/entity/draggable_object.dart';

import '/app/core/exporter.dart';
import '/app/pages/home/controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends BaseView<HomeController> {
  HomeView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return Center(
            child: ZoomableSurface(
              maxZoom: 4,
              child: Stack(
                children: [
                  Container(
                    color: Colors.green,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  ...objectPositions.value.map(
                    (model) {
                      final bool isOverlapping = objectPositions.value.any(
                        (otherModel) =>
                            otherModel.position != model.position &&
                            controller.checkCollision(
                              model.position,
                              otherModel.position,
                              50,
                            ),
                      );
                      return DraggableObject(
                        position: model.position,
                        isOverlapping: isOverlapping,
                        isDragging: controller.isDragging.value,
                        onDragStart: () {
                          controller.isDragging.value = true;
                        },
                        onDragEnd: () {
                          controller.isDragging.value = false;
                        },
                        onPositionChanged: (newPosition) {
                          final int index =
                              objectPositions.value.indexOf(model);
                          if (index != -1) {
                            objectPositions.value[index] = DraggableObjectModel(
                              position: newPosition,
                              width: model.width,
                              height: model.height,
                              asset: model.asset,
                            );
                          }
                        },
                        checkCollision: controller.checkCollision,
                        width: model.width,
                        height: model.height,
                        objectWidget: Lottie.asset(model.asset),
                      );
                    },
                  ),
                  Positioned(
                    top: 50,
                    left: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final newModel = DraggableObjectModel(
                          position: const Offset(100, 100),
                          width: 100,
                          height: 100,
                          asset: 'assets/lottie/mountain.json',
                        );
                        objectPositions.value.add(newModel);
                        objectPositions.refresh();
                        if (kDebugMode) {
                          print(
                            'Added object at: ${newModel.position}',
                          );
                        } // Debug print
                      },
                      child: const Text('Add Object'),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        objectPositions.value.clear();
                        if (kDebugMode) {
                          print('Cleared all objects');
                        } //
                        objectPositions.value.clear();
                        objectPositions.refresh();
                      },
                      child: const Text('Clear Objects'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
