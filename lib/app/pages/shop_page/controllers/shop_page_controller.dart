import 'package:getx_template/app/pages/planet/controllers/planet_controller.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';

class PurchaseAbleBuilding {
  final String name;
  final int price;
  final String image;
  final bool isPurchased;
  final VoidCallback? onTap;
  Map<Resource, int>? buyRequirements;

  PurchaseAbleBuilding({
    required this.name,
    required this.price,
    required this.image,
    required this.isPurchased,
    this.onTap,
  });

  // Method to check if the building can be purchased
  bool canPurchase() {
    if (buyRequirements != null) {
      for (final entry in buyRequirements!.entries) {
        if (entry.key.currentCount < entry.value) {
          return false;
        }
      }
    }
    return true;
  }

  // Method to purchase the building
  bool purchaseBuilding() {
    if (canPurchase()) {
      // Deduct resources
      if (buyRequirements != null) {
        for (final entry in buyRequirements!.entries) {
          entry.key.currentCount -= entry.value;
        }
      }
      return true;
    }
    return false;
  }
}

class ShopPageController extends BaseController {
  final buildingList = Rx<List<PurchaseAbleBuilding>?>(null);
  final methaneCount = Rx<int?>(null);
  final hydrogenSulfideCount = Rx<int?>(null);
  final ammoniaCount = Rx<int?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    methaneCount.value = await prefs.getInt(prefMethaneCount);
    hydrogenSulfideCount.value = await prefs.getInt(prefHydrogenSulfideCount);
    ammoniaCount.value = await prefs.getInt(prefAmmoniaCount);

    if (kDebugMode) {
      print('methaneCount: $methaneCount');
      print('hydrogenSulfideCount: $hydrogenSulfideCount');
      print('ammoniaCount: $ammoniaCount');
    }

    await getBuildingList();
  }

  Future<void> getBuildingList() async {
    buildingList.value = [
      PurchaseAbleBuilding(
        name: 'Sulfur Building',
        price: 100,
        image: 'assets/images/building_1.png',
        isPurchased: await prefs.getBool(prefHasHydrogenSulfide),
        onTap: () async {
          // Check if the building can be purchased
          final alreadyPurchased = await prefs.getBool(prefHasHydrogenSulfide);
          if (alreadyPurchased) {
            toast('You already have this building');
            return;
          }
          final confirmation = await confirmationModal(
            msg: 'Do you want to buy this building?',
          );
          if (confirmation) {
            // Do something
            await prefs.setBool(
              key: prefHasHydrogenSulfide,
              value: true,
            );
          }
        },
      ),
      PurchaseAbleBuilding(
        name: 'Ammonia Building',
        price: 200,
        image: 'assets/images/building_2.png',
        isPurchased: await prefs.getBool(prefHasAmmonia),
        onTap: () async {
          // Check if the building can be purchased
          final alreadyPurchased = await prefs.getBool(prefHasAmmonia);
          if (alreadyPurchased) {
            toast('You already have this building');
            return;
          }

          final confirmation = await confirmationModal(
            msg: 'Do you want to buy this building?',
          );
          if (confirmation) {
            // Do something
            await prefs.setBool(
              key: prefHasAmmonia,
              value: true,
            );
          }
        },
      ),
    ];
  }
}
