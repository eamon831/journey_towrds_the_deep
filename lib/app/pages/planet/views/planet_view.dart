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
