import 'package:getx_template/app/bindings/initial_binding.dart';
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
                top: 100, // Adjust these values as needed
                left: 50, // Adjust these values as needed
                child: Row(
                  children: [
                    BuildingView(
                      onTap: () => controller.upgradeObject(
                        building: methaneBuilding,
                      ),
                      onDoubleTap: () async {
                        print('Producing Methane');
                        methaneBuilding.value.produceResource();
                        print(
                          'Methane produced ${methaneBuilding.value.resource.currentCount}',
                        );
                        methaneBuilding.refresh();
                        await controller.prefs.setInt(
                          key: prefMethaneCount,
                          value: methaneBuilding.value.resource.currentCount,
                        );
                      },
                      building: methaneBuilding.value,
                    ),
                    10.width,
                    if (controller.hasHydrogenSulfide.value)
                      BuildingView(
                        onTap: () => controller.upgradeObject(
                          building: hydrogenSulfideBuilding,
                        ),
                        onDoubleTap: () {
                          print('Producing Sulfur');
                          hydrogenSulfideBuilding.value.produceResource();
                          print(
                            'Sulfur produced ${hydrogenSulfideBuilding.value.resource.currentCount}',
                          );
                          hydrogenSulfideBuilding.refresh();
                          controller.prefs.setInt(
                            key: prefHydrogenSulfideCount,
                            value: hydrogenSulfideBuilding
                                .value.resource.currentCount,
                          );
                        },
                        building: hydrogenSulfideBuilding.value,
                      ),
                    10.width,
                    if (controller.hasAmmonia.value)
                      BuildingView(
                        onTap: () => controller.upgradeObject(
                          building: ammoniaBuilding,
                        ),
                        onDoubleTap: () {
                          print('Producing Ammonia');
                          ammoniaBuilding.value.produceResource();
                          print(
                            'Ammonia produced ${ammoniaBuilding.value.resource.currentCount}',
                          );
                          ammoniaBuilding.refresh();
                          controller.prefs.setInt(
                            key: prefAmmoniaCount,
                            value: ammoniaBuilding.value.resource.currentCount,
                          );
                        },
                        building: ammoniaBuilding.value,
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
                      count: methaneBuilding.value.resource.currentCount
                          .toString(),
                    ),
                    if (controller.hasHydrogenSulfide.value)
                      CountView(
                        title: 'Hydrogen Sulfide',
                        count: hydrogenSulfideBuilding
                            .value.resource.currentCount
                            .toString(),
                      ),
                    if (controller.hasAmmonia.value)
                      CountView(
                        title: 'Ammonia',
                        count: ammoniaBuilding.value.resource.currentCount
                            .toString(),
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
