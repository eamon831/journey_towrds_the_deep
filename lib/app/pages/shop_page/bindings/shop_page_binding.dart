import '/app/core/exporter.dart';
import '/app/pages/shop_page/controllers/shop_page_controller.dart';

class ShopPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopPageController>(
      ShopPageController.new,
      fenix: true,
    );
  }
}
