import 'package:get/get.dart';
import '/app/pages/local_db_data/bindings/local_db_data_binding.dart';
import '/app/pages/local_db_data/views/local_db_data_view.dart';

import '/app/pages/home/bindings/home_binding.dart';
import '/app/pages/home/views/home_view.dart';
import '/app/pages/root/bindings/root_binding.dart';
import '/app/pages/root/views/root_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.root;

  static final routes = [
    GetPage(
      name: _Paths.root,
      page: RootView.new,
      binding: RootBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.localDbData,
      page: LocalDbDataView.new,
      binding: LocalDbDataBinding(),
    ),
  ];
}
