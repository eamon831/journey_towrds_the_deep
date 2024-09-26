import 'package:get/get.dart';

import '/app/pages/home/bindings/home_binding.dart';
import '/app/pages/home/views/home_view.dart';
import '/app/pages/splash_page/bindings/splash_page_binding.dart';
import '/app/pages/splash_page/views/splash_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splashPage;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.splashPage,
      page: SplashPageView.new,
      binding: SplashPageBinding(),
    ),
  ];
}
