import '/app/core/exporter.dart';
import '/app/pages/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      HomeController.new,
      fenix: true,
    );
  }
}
