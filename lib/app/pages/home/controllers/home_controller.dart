import '/app/core/exporter.dart';

class HomeController extends BaseController {
  void goToLocalDbPage() {
    Get.toNamed(
      Routes.localDbData,
    );
  }
}
