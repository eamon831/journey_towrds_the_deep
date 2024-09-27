import '/app/core/exporter.dart';
import '/app/pages/planet/controllers/planet_controller.dart';

class PlanetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanetController>(
      PlanetController.new,
      fenix: true,
    );
  }
}
