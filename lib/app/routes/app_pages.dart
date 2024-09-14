import 'package:get/get.dart';
import '/app/pages/home/bindings/home_binding.dart';
import '/app/pages/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
  ];
}
