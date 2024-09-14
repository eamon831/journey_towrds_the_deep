import 'package:getx_template/app/bindings/initial_binding.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/pages/home/controllers/home_controller.dart';

class HomeView extends BaseView<HomeController> {
  HomeView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return const CustomAppBar(
      appBarTitleText: 'GetX Templates on GitHub',
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      // mainAxisAlignment: centerMAA,
      children: [
        10.height,
        SelectiveButton(
          onPressed: controller.goToLocalDbPage,
          text: 'Local DB',
          isSelected: true,
          color: Colors.blue,
          textColor: Colors.white,
          width: 100,
          height: 20,
          borderRadius: 10,
          elevation: 5,
          padding: 10,
          margin: 10,
          icon: Icons.image,
          iconSize: 20,
          iconColor: Colors.white,
          iconPadding: 10,
          iconMargin: 10,
        ),
        10.height,

      ],
    );
  }
}
