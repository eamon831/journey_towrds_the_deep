import 'package:get/get.dart';

import '/app/pages/planet/bindings/planet_binding.dart';
import '/app/pages/planet/views/planet_view.dart';
import '/app/pages/shop_page/bindings/shop_page_binding.dart';
import '/app/pages/shop_page/views/shop_page_view.dart';
import '/app/pages/splash_page/bindings/splash_page_binding.dart';
import '/app/pages/splash_page/views/splash_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splashPage;

  static final routes = [
    GetPage(
      name: Routes.splashPage,
      page: SplashPageView.new,
      binding: SplashPageBinding(),
    ),
    GetPage(
      name: Routes.planet,
      page: PlanetView.new,
      binding: PlanetBinding(),
    ),
    GetPage(
      name: Routes.shopPage,
      page: ShopPageView.new,
      binding: ShopPageBinding(),
    ),
  ];
}
