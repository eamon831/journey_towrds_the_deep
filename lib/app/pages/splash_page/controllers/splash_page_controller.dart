import '/app/core/exporter.dart';

class SplashPageController extends BaseController {
  @override
  void onInit() {
    super.onInit();
    print('SplashPageController');
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Get.offNamed(Routes.home);
      },
    );
  }
}
