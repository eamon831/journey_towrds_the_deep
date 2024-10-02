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
                        object: methane,
                      ),
                      onDoubleTap: () {
                        print('double tap');
                        controller.methaneCount.value++;
                        controller.methaneCount.refresh();
                      },
                      child: Lottie.asset(
                        'assets/lottie/mountain.json',
                        width: Get.width * 0.2,
                        height: Get.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 70,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // show this view as selected
                        controller.selectedObject.value = PlanetObject(
                          name: 'Sulfur',
                          description:
                              'Sulfur is a chemical element with the symbol S and atomic number 16.',
                          image: 'assets/images/sulfur.jpg',
                          type: 'Solid',
                        );
                      },
                      onDoubleTap: () {
                        print('double tap');
                      },
                      child: Lottie.asset(
                        'assets/lottie/mountain.json',
                        width: Get.width * 0.2,
                        height: Get.height * 0.2,
                        fit: BoxFit.cover,
                      ),
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
                      count: controller.methaneCount.value.toString(),
                    ),
                    CountView(
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
}
