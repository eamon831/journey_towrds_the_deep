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
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Lottie.asset(
                  'assets/lottie/night_bg.json',
                  fit: BoxFit.cover,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/land.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (methaneBuilding.value != null)
                    Positioned(
                      left: 10,
                      top: 250,
                      child: BuildingView(
                        onTap: () => controller.upgradeObject(
                          building: methaneBuilding,
                        ),
                        onDoubleTap: () => controller.produceResource(
                          building: methaneBuilding,
                        ),
                        building: methaneBuilding.value!,
                      ),
                    ),
                  if (hydrogenSulfideBuilding.value != null)
                    Positioned(
                      left: 200,
                      bottom: 60,
                      child: BuildingView(
                        onTap: () => controller.upgradeObject(
                          building: hydrogenSulfideBuilding,
                        ),
                        onDoubleTap: () => controller.produceResource(
                          building: hydrogenSulfideBuilding,
                        ),
                        building: hydrogenSulfideBuilding.value!,
                      ),
                    ),
                  if (ammoniaBuilding.value != null)
                    Positioned(
                      bottom: 10,
                      child: BuildingView(
                        onTap: () => controller.upgradeObject(
                          building: ammoniaBuilding,
                        ),
                        onDoubleTap: () => controller.produceResource(
                          building: ammoniaBuilding,
                        ),
                        building: ammoniaBuilding.value!,
                      ),
                    ),
                  if (waterBuilding.value != null)
                    Positioned(
                      bottom: 15,
                      left: 100,
                      child: BuildingView(
                        onTap: () => controller.upgradeObject(
                          building: waterBuilding,
                        ),
                        onDoubleTap: () => controller.produceResource(
                          building: waterBuilding,
                        ),
                        building: waterBuilding.value!,
                      ),
                    ),
                  if (true)
                    Positioned(
                      // Example positioning
                      top: 30, // Adjust these values as needed
                      left: 20, // Adjust these values as needed
                      child: ElevatedButton(
                        onPressed: controller.clearBuilding,
                        child: const Text('Clear Building'),
                      ),
                    ),
                  Positioned(
                    top: 50,
                    right: 0,
                    child: Column(
                      children: [
                        if (methaneBuilding.value != null)
                          CountView(
                            title: 'Methane',
                            count:
                                methaneBuilding.value!.currentCount.toString(),
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
                            count:
                                ammoniaBuilding.value!.currentCount.toString(),
                          ),
                        if (waterBuilding.value != null)
                          CountView(
                            title: 'Water',
                            count: waterBuilding.value!.currentCount.toString(),
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
              ),
            ],
          );

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
              if (methaneBuilding.value != null)
                Positioned(
                  left: 10,
                  child: BuildingView(
                    onTap: () => controller.upgradeObject(
                      building: methaneBuilding,
                    ),
                    onDoubleTap: () => controller.produceResource(
                      building: methaneBuilding,
                    ),
                    building: methaneBuilding.value!,
                  ),
                ),
              if (hydrogenSulfideBuilding.value != null)
                Positioned(
                  right: 10,
                  child: BuildingView(
                    onTap: () => controller.upgradeObject(
                      building: hydrogenSulfideBuilding,
                    ),
                    onDoubleTap: () => controller.produceResource(
                      building: hydrogenSulfideBuilding,
                    ),
                    building: hydrogenSulfideBuilding.value!,
                  ),
                ),
              if (ammoniaBuilding.value != null)
                Positioned(
                  bottom: 10,
                  child: BuildingView(
                    onTap: () => controller.upgradeObject(
                      building: ammoniaBuilding,
                    ),
                    onDoubleTap: () => controller.produceResource(
                      building: ammoniaBuilding,
                    ),
                    building: ammoniaBuilding.value!,
                  ),
                ),
              if (waterBuilding.value != null)
                Positioned(
                  bottom: 30,
                  left: 10,
                  child: BuildingView(
                    onTap: () => controller.upgradeObject(
                      building: waterBuilding,
                    ),
                    onDoubleTap: () => controller.produceResource(
                      building: waterBuilding,
                    ),
                    building: waterBuilding.value!,
                  ),
                ),
              if (true)
                Positioned(
                  // Example positioning
                  top: 30, // Adjust these values as needed
                  left: 20, // Adjust these values as needed
                  child: ElevatedButton(
                    onPressed: controller.clearBuilding,
                    child: const Text('Clear Building'),
                  ),
                ),
              Positioned(
                top: 50,
                right: 0,
                child: Column(
                  children: [
                    if (methaneBuilding.value != null)
                      CountView(
                        title: 'Methane',
                        count: methaneBuilding.value!.currentCount.toString(),
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
                        title: 'Water',
                        count: waterBuilding.value!.currentCount.toString(),
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
