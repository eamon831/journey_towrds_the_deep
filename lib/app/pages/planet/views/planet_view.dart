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
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Lottie.asset(
              'assets/lottie/night_bg.json',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Obx(
                  () => Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
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
                          left: constraint.maxHeight/50 ,
                          bottom: constraint.maxHeight/4,
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
                          left: constraint.maxHeight/5 ,
                          bottom: constraint.maxHeight/10,
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
                          left: constraint.maxHeight/2.6 ,
                          bottom: constraint.maxHeight/4,
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
                      if (bacteriaPond.value != null)
                        Positioned(
                          left: constraint.maxHeight/1.1 ,
                          bottom: constraint.maxHeight/10,
                          child: BuildingView(
                            onTap: () => controller.upgradeObject(
                              building: bacteriaPond,
                            ),
                            onDoubleTap: () => controller.produceResource(
                              building: bacteriaPond,
                            ),
                            building: bacteriaPond.value!,
                          ),
                        ),
                      if (fishPond.value != null)
                        Positioned(
                          left: constraint.maxHeight/1.4 ,
                          bottom: constraint.maxHeight/5,
                          child: BuildingView(
                            onTap: () => controller.upgradeObject(
                              building: fishPond,
                            ),
                            onDoubleTap: () => controller.produceResource(
                              building: fishPond,
                            ),
                            building: fishPond.value!,
                          ),
                        ),
                      if (waterBuilding.value != null)
                        Positioned(
                          left: constraint.maxHeight/1.9 ,
                          bottom: constraint.maxHeight/15,
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
                      if (false)
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
                                count: methaneBuilding.value!.currentCount
                                    .toString(),
                              ),
                            if (hydrogenSulfideBuilding.value != null)
                              CountView(
                                title: 'Hydrogen Sulfide',
                                count: hydrogenSulfideBuilding
                                    .value!.currentCount
                                    .toString(),
                              ),
                            if (ammoniaBuilding.value != null)
                              CountView(
                                title: 'Ammonia',
                                count: ammoniaBuilding.value!.currentCount
                                    .toString(),
                              ),
                            if (waterBuilding.value != null)
                              CountView(
                                title: 'Water',
                                count: waterBuilding.value!.currentCount
                                    .toString(),
                              ),
                            if (bacteriaPond.value != null)
                              CountView(
                                title: 'Bacteria  ',
                                count:
                                    bacteriaPond.value!.currentCount.toString(),
                              ),
                            if (fishPond.value != null)
                              CountView(
                                title: 'Fish',
                                count: fishPond.value!.currentCount.toString(),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
