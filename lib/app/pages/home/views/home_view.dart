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
          return Stack(
            children: [
              ZoomableSurface(
                maxZoom: 4,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/base_surface.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ...objectPositions.value.map(
                      (model) {
                        final bool isOverlapping = objectPositions.value.any(
                          (otherModel) {
                            return otherModel.position != model.position &&
                              controller.checkCollision(
                                model.position,
                                otherModel.position,
                                50,
                              );
                          },
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
                            final int index = objectPositions.value.indexOf(
                              model,
                            );
                            if (index != -1) {
                              objectPositions.value[index] =
                                  DraggableObjectModel(
                                position: newPosition,
                                width: model.width,
                                height: model.height,
                                asset: model.asset,
                                onTap: model.onTap,
                                onDoubleTap: model.onDoubleTap,
                              );
                            }
                          },
                          checkCollision: controller.checkCollision,
                          width: model.width,
                          height: model.height,
                          objectWidget: Lottie.asset(model.asset),
                          onTap: (value) {
                            model.onTap?.call(value);
                          },
                          onDoubleTap: model.onDoubleTap ?? () {},
                          isSelected: (value) {
                            return selectedObject.value?.position.dx ==
                                    value.position.dx &&
                                selectedObject.value?.position.dy ==
                                    value.position.dy;
                          },
                          model: model,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                right: 0,
                child: Column(
                  children: [
                    if (true)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              final newModel = DraggableObjectModel(
                                position: const Offset(100, 100),
                                width: 100,
                                height: 100,
                                asset: 'assets/lottie/mountain.json',
                                onTap: (value) {
                                  if (kDebugMode) {
                                    print('Tapped object');
                                  }
                                  // check if the object is selected
                                  if (selectedObject.value?.position.dx ==
                                          value.position.dx &&
                                      selectedObject.value?.position.dy ==
                                          value.position.dy) {
                                    selectedObject.value = null;
                                  } else {
                                    selectedObject.value = value;
                                  }
                                  print(selectedObject.value?.toJson());
                                  print(value.toJson());
                                  selectedObject.refresh();
                                  controller.update();
                                },
                                onDoubleTap: () {
                                  if (kDebugMode) {
                                    print('Double tapped object');
                                  } // Debug print
                                  controller.methaneCount.value += 1;
                                  controller.methaneCount.refresh();
                                },
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
                          ElevatedButton(
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
                          ElevatedButton(
                            onPressed: () {
                              if (kDebugMode) {
                                print('All dx and dy:');
                                objectPositions.value.forEach((element) {
                                  print('dx: ${element.position.dx}');
                                  print('dy: ${element.position.dy}');
                                });
                              }
                            },
                            child: const Text('Print all dx and dy'),
                          ),
                        ],
                      ),
                    _buildCountView(
                      title: 'Methane',
                      count: controller.methaneCount.value.toString(),
                    ),
                    _buildCountView(
                      title: 'Sulfur',
                      count: Random().nextInt(100).toString(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCountView({
    required String title,
    required String count,
  }) {
    return Row(
      children: [
        const InkWell(
          child: Icon(
            Icons.info,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                ':',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
