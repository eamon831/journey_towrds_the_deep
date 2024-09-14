import '/app/core/exporter.dart';
import '/app/pages/home/controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends BaseView<HomeController> {
  HomeView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
