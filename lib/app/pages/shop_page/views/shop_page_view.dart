import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/pages/shop_page/controllers/shop_page_controller.dart';

// ignore: must_be_immutable
class ShopPageView extends BaseView<ShopPageController> {
  ShopPageView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/base_surface.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              HorizontalList(
                itemCount: controller.buildingList.value?.length ?? 0,
                itemBuilder: (context, index) {
                  final building = controller.buildingList.value![index];
                  return InkWell(
                    onTap: building.onTap,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: building.isPurchased
                            ? AppColors.grey
                            : AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            building.name,
                            style: boldTextStyle(color: AppColors.white),
                          ),
                          10.height,
                        ],
                      ),
                    ).paddingOnly(left: 16, right: 16),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                child: Row(
                  children: [
                    if (controller.hydrogenSulfideCount.value != null)
                      Text(
                        'Hydrogen Sulfide: ${controller.hydrogenSulfideCount.value}',
                      ),
                    if (controller.ammoniaCount.value != null)
                      Text(
                        'Ammonia: ${controller.ammoniaCount.value}',
                      ),
                    if (controller.methaneCount.value != null)
                      Text(
                        'Methane: ${controller.methaneCount.value}',
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
