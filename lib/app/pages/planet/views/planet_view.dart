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
                    InkWell(
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
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Methane',
                            style: TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
/*
                      child: Lottie.asset(
                        'assets/lottie/mountain.json',
                        width: Get.width * 0.2,
                        height: Get.height * 0.2,
                        fit: BoxFit.cover,
                      ),
*/
                    ),
                    10.width,
                    if(controller.hasHydrogenSulfide.value)
                    InkWell(
                      onTap: () => controller.upgradeObject(
                        building: sulfurBuilding,
                      ),
                      onDoubleTap: () {
                        print('Producing Sulfur');
                        sulfurBuilding.value.produceResource();
                        print(
                          'Sulfur produced ${sulfurBuilding.value.resource.currentCount}',
                        );
                        sulfurBuilding.refresh();
                        controller.prefs.setInt(
                          key: prefHydrogenSulfideCount,
                          value: sulfurBuilding.value.resource.currentCount,
                        );
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Sulfur',
                            style: TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
/*
                      child: Lottie.asset(
                        'assets/lottie/mountain.json',
                        width: Get.width * 0.2,
                        height: Get.height * 0.2,
                        fit: BoxFit.cover,
                      ),
*/
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
                    CountView(
                      title: 'Sulfur',
                      count:
                          sulfurBuilding.value.resource.currentCount.toString(),
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
