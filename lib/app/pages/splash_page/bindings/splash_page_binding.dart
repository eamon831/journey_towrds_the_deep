import '/app/core/exporter.dart';
import '/app/pages/splash_page/controllers/splash_page_controller.dart';

class SplashPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashPageController>(
      SplashPageController.new,
      fenix: true,
    );
  }
}
