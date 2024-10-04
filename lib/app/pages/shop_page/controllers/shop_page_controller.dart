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
  Map<Resource, int>? buyRequirements;
  ResourceBuilding? resourceBuilding;

  PurchaseAbleBuilding({
    required this.name,
    required this.price,
    required this.image,
    required this.isPurchased,
    this.buyRequirements,
    this.resourceBuilding,
  });

  // Method to check if the building can be purchased
  Future<bool> canPurchase() async {
    if (isPurchased) {
      return false;
    }
    if (buyRequirements != null) {
      final dbHelper = DbHelper.instance;

      final keys = buyRequirements?.keys.toList() ?? [];
      for (final key in keys) {
        final data = await dbHelper.getAllWhr(
          tbl: tableBuildings,
          where: 'resource_type = ?',
          whereArgs: [
            key.slug,
          ],
        );
        if (data.isEmpty) {
          return false;
        }

        if (data[0]['current_count'] < buyRequirements![key]!) {
          return false;
        }
      }
    }
    return true;
  }

  // Method to purchase the building
  Future<bool> purchaseBuilding() async {
    if (await canPurchase()) {
      // Deduct resources
      if (buyRequirements != null) {
        final dbHelper = DbHelper.instance;
        final keys = buyRequirements?.keys.toList() ?? [];

        await Future.forEach<Resource>(
          keys,
          (key) async {
            // get count of the resource from the database and deduct the amount required
            final data = await dbHelper.getAllWhr(
              tbl: tableBuildings,
              where: 'resource_type = ?',
              whereArgs: [
                key.slug,
              ],
            );

            final currentCount = data[0]['current_count'];
            final newCount = currentCount - buyRequirements![key]!;
            await dbHelper.updateWhere(
              tbl: tableBuildings,
              where: 'resource_type = ?',
              whereArgs: [
                key.slug,
              ],
              data: {
                'current_count': newCount,
              },
            );
          },
        );
      }
      return true;
    }
    return false;
  }
}

class ShopPageController extends BaseController {
  final buildingList = Rx<List<PurchaseAbleBuilding>?>(null);
  final methaneCount = Rx<num>(methaneBuilding.value!.currentCount);
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
        image: 'assets/lottie/methane_1.json',
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
      ),
      PurchaseAbleBuilding(
        name: 'Ammonia Building',
        price: 200,
        image: 'assets/lottie/methane_1.json',
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
      ),
      PurchaseAbleBuilding(
        name: 'Water Purification Building',
        price: 200,
        image: 'assets/images/water_1.png',
        isPurchased: await dbHelper.getAllWhr(
          tbl: tableBuildings,
          where: 'resource_type = ?',
          whereArgs: [
            water.slug,
          ],
        ).then(
          (value) {
            return value.isNotEmpty;
          },
        ),
        buyRequirements: {
          methane: 20,
          hydrogenSulfide: 10,
          ammonia: 30,
        },
        resourceBuilding: ResourceBuilding(
          resource: water,
          resourceType: water.slug,
          upgradeRequirements: {
            methane: 20,
            hydrogenSulfide: 10,
            ammonia: 30,
          },
          currentCount: 0,
        ),
      ),
    ];
  }

  Future<void> purchaseBuilding(
    PurchaseAbleBuilding building,
  ) async {
    if (await building.canPurchase()) {
      final confirmation = await confirmationModal(
        msg: 'Do you want to buy this building?',
      );
      if (confirmation) {
        if (await building.purchaseBuilding()) {
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
