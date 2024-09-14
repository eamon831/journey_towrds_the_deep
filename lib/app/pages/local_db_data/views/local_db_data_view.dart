import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/pages/local_db_data/controllers/local_db_data_controller.dart';

// ignore: must_be_immutable
class LocalDbDataView extends BaseView<LocalDbDataController> {
  LocalDbDataView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            SelectiveButton(
              onPressed: controller.insertList,
              text: 'Insert List',
              isSelected: true,
              color: AppColors.buttonBgColor,
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
            SelectiveButton(
              onPressed: controller.getUserList,
              text: 'Fetch List',
              isSelected: true,
              color: Colors.red,
              textColor: Colors.white,
              width: 100,
              height: 20,
              borderRadius: 10,
              elevation: 5,
              padding: 10,
              margin: 0,
              icon: Icons.image,
              iconSize: 20,
              iconColor: Colors.white,
              iconPadding: 10,
              iconMargin: 10,
            ),
            10.height,
            SelectiveButton(
              onPressed: controller.deleteAll,
              text: 'Delete List',
              isSelected: true,
              color: Colors.red,
              textColor: Colors.white,
              width: 100,
              height: 20,
              borderRadius: 10,
              elevation: 5,
              padding: 10,
              margin: 0,
              icon: Icons.image,
              iconSize: 20,
              iconColor: Colors.white,
              iconPadding: 10,
              iconMargin: 10,
            ),

          ],
        ),
        Expanded(
          child: Obx(
            () => controller.userList.value == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.userList.value!.length,
                    itemBuilder: (context, index) {
                      final user = controller.userList.value![index];
                      return ListTile(
                        title: Text(user.userName!),
                        subtitle: Text(user.fullName!),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
