import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/pages/planet/controllers/planet_controller.dart';

// ignore: must_be_immutable
class PlanetView extends BaseView<PlanetController> {
  PlanetView({super.key});

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
            alignment: Alignment.center,
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
              Positioned(
                // Example positioning
                top: 30, // Adjust these values as needed
                left: 50, // Adjust these values as needed
                child: Row(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          BuildingView(
                            onTap: () => controller.upgradeObject(
                              building: methaneBuilding,
                            ),
                            onDoubleTap: () => controller.produceResource(
                              building: methaneBuilding,
                            ),
                            building: methaneBuilding.value,
                          ),
                          10.height,
                          if (hydrogenSulfideBuilding.value != null)
                            BuildingView(
                              onTap: () => controller.upgradeObject(
                                building: hydrogenSulfideBuilding,
                              ),
                              onDoubleTap: () => controller.produceResource(
                                building: hydrogenSulfideBuilding,
                              ),
                              building: hydrogenSulfideBuilding.value!,
                            ),
                          10.height,
                          if (ammoniaBuilding.value != null)
                            BuildingView(
                              onTap: () => controller.upgradeObject(
                                building: ammoniaBuilding,
                              ),
                              onDoubleTap: () => controller.produceResource(
                                building: ammoniaBuilding,
                              ),
                              building: ammoniaBuilding.value!,
                            ),
                          if (waterBuilding.value != null)
                            BuildingView(
                              onTap: () => controller.upgradeObject(
                                building: waterBuilding,
                              ),
                              onDoubleTap: () => controller.produceResource(
                                building: waterBuilding,
                              ),
                              building: waterBuilding.value!,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Insert Building'),
                        ),
                        ElevatedButton(
                          onPressed: controller.clearBuilding,
                          child: Text('Clear Building'),
                        ),
                        ElevatedButton(
                          onPressed: controller.buildBuilding,
                          child: Text('Build Building'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                right: 0,
                child: Column(
                  children: [
                    CountView(
                      title: 'Methane',
                      count: methaneBuilding.value.currentCount.toString(),
                    ),
                    if (hydrogenSulfideBuilding.value != null)
                      CountView(
                        title: 'Hydrogen Sulfide',
                        count: hydrogenSulfideBuilding.value!.currentCount
                            .toString(),
                      ),
                    if (ammoniaBuilding.value != null)
                      CountView(
                        title: 'Ammonia',
                        count: ammoniaBuilding.value!.currentCount.toString(),
                      ),
                    if (waterBuilding.value != null)
                      CountView(
                        title: 'Ammonia',
                        count: ammoniaBuilding.value!.currentCount.toString(),
                      ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Column(
                  children: [
                    IconTextButton(
                      text: 'Shop',
                      icon: Icons.add,
                      onTap: controller.goToShop,
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
}
