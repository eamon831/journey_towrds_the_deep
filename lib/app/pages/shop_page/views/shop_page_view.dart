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
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: Get.back,
                ),
              ),
              HorizontalList(
                itemCount: controller.buildingList.value?.length ?? 0,
                itemBuilder: (context, index) {
                  final building = controller.buildingList.value![index];
                  return InkWell(
                    onTap: () => controller.purchaseBuilding(building),
                    child: Container(
                      //   height: 100,
                      //width: 100,
                      decoration: BoxDecoration(
                        color: building.isPurchased
                            ? AppColors.grey
                            : AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: building.image.contains('.json')
                                ? Lottie.asset(
                                    building.image,
                                    width: Get.width * 0.2,
                                    height: Get.height * 0.2,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(building.image),
                          ),
                          Text(
                            building.name,
                            style: boldTextStyle(color: AppColors.white),
                          ),
                          10.height,
                          Column(
                            crossAxisAlignment: startCAA,
                            children: [
                              Text(
                                'Price',
                                style: primaryTextStyle(
                                  color: AppColors.white,
                                ),
                              ),
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: building.buyRequirements?.entries.map(
                                      (entry) {
                                        return Chip(
                                          label: Text(
                                              '${entry.key.name}: ${entry.value}'),
                                        );
                                      },
                                    ).toList() ??
                                    [],
                              ),
                            ],
                          ),
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
                    _countViews(
                      label: 'Methane',
                      value: controller.methaneCount.value.toString(),
                    ),
                    if (controller.hydrogenSulfideCount.value != null)
                      _countViews(
                        label: 'Hydrogen Sulfide',
                        value: controller.hydrogenSulfideCount.value.toString(),
                      ),
                    if (controller.ammoniaCount.value != null)
                      _countViews(
                        label: 'Ammonia',
                        value: controller.ammoniaCount.value.toString(),
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

  Widget _countViews({
    required String label,
    required String value,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: centerCAA,
        mainAxisAlignment: centerMAA,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const Text(
            ' : ',
          ),
          Text(
            value,
          ),
        ],
      ),
    );
  }
}
