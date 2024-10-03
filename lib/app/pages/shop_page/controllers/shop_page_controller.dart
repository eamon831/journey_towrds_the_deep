import 'dart:convert';

import 'package:getx_template/app/entity/resource_building.dart';
import 'package:getx_template/app/pages/planet/controllers/planet_controller.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/entity/resource.dart';

class PurchaseAbleBuilding {
  final String name;
  final int price;
  final String image;
  final bool isPurchased;
  final VoidCallback? onTap;
  Map<Resource, int>? buyRequirements;
  ResourceBuilding? resourceBuilding;

  PurchaseAbleBuilding({
    required this.name,
    required this.price,
    required this.image,
    required this.isPurchased,
    this.buyRequirements,
    this.onTap,
    this.resourceBuilding,
  });

  // Method to check if the building can be purchased
  bool canPurchase() {
    if (isPurchased) {
      return false;
    }
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
  final methaneCount = Rx<num>(methaneBuilding.value.currentCount);
  final hydrogenSulfideCount =
      Rx<num?>(hydrogenSulfideBuilding.value?.currentCount);
  final ammoniaCount = Rx<num?>(ammoniaBuilding.value?.currentCount);

  @override
  Future<void> onInit() async {
    super.onInit();

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
        isPurchased: await dbHelper.getAllWhr(
          tbl: tableBuildings,
          where: 'resource_type = ?',
          whereArgs: [
            hydrogenSulfide.slug,
          ],
        ).then(
          (value) {
            return value.isNotEmpty;
          },
        ),
        buyRequirements: {
          methane: 10,
        },
        resourceBuilding: ResourceBuilding(
          resource: hydrogenSulfide,
          resourceType: hydrogenSulfide.slug,
          upgradeRequirements: {
            methane: 10,
          },
          currentCount: 0,
        ),
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
        isPurchased: await dbHelper.getAllWhr(
          tbl: tableBuildings,
          where: 'resource_type = ?',
          whereArgs: [
            ammonia.slug,
          ],
        ).then(
          (value) {
            return value.isNotEmpty;
          },
        ),
        buyRequirements: {
          methane: 20,
          hydrogenSulfide: 10,
        },
        resourceBuilding: ResourceBuilding(
          resource: ammonia,
          resourceType: ammonia.slug,
          upgradeRequirements: {
            methane: 20,
            hydrogenSulfide: 10,
          },
          currentCount: 0,
        ),
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

  Future<void> purchaseBuilding(
    PurchaseAbleBuilding building,
  ) async {
    if (building.canPurchase()) {
      final confirmation = await confirmationModal(
        msg: 'Do you want to buy this building?',
      );
      if (confirmation) {
        if (building.purchaseBuilding()) {
          await dbHelper.insertList(
            deleteBeforeInsert: false,
            tableName: tableBuildings,
            dataList: [
              building.resourceBuilding!.toJson(),
            ],
          );

          final keys = building.buyRequirements?.keys.toList() ?? [];

          await Future.forEach<Resource>(
            keys,
            (key) async {
              await dbHelper.updateWhere(
                tbl: tableBuildings,
                where: 'resource_type = ?',
                whereArgs: [
                  key.slug,
                ],
                data: {
                  'resource': jsonEncode(key.toJson()),
                },
              );
            },
          );

          Get.offAllNamed(Routes.planet);
        } else {
          toast('Not enough resources to buy this building');
        }
      }
    } else {
      toast('You can not to buy this building');
    }
  }
}
