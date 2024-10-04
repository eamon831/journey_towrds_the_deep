import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/entity/resource.dart';
import '/app/entity/resource_building.dart';

// ResourceBuilding class that manages resource generation and upgrades

class PlanetController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();

    await _init();

    await _initHydrogenSulfideBuilding();

    await _initAmmoniaBuilding();

    await _initWaterBuilding();

    methaneBuilding.refresh();
  }

  Future<void> _init() async {
    final methaneBuildingData = await dbHelper.getAllWhr(
      tbl: tableBuildings,
      where: 'resource_type = ?',
      whereArgs: [
        'methane',
      ],
    );
    if (methaneBuildingData.isNotEmpty) {
      methaneBuilding.value = ResourceBuilding.fromJson(methaneBuildingData[0]);
      methane = methaneBuilding.value!.resource;
    } else {
      await dbHelper.insertList(
        deleteBeforeInsert: false,
        tableName: tableBuildings,
        dataList: [methaneBuilding.value!.toJson()],
      );
    }
  }

  Future<void> _initHydrogenSulfideBuilding() async {
    final hydrogenSulfideBuildingData = await dbHelper.getAllWhr(
      tbl: tableBuildings,
      where: 'resource_type = ?',
      whereArgs: [
        'hydrogen-sulfide',
      ],
    );
    if (hydrogenSulfideBuildingData.isNotEmpty) {
      hydrogenSulfideBuilding.value = ResourceBuilding.fromJson(
        hydrogenSulfideBuildingData[0],
      );
      hydrogenSulfide = hydrogenSulfideBuilding.value!.resource;
    }
  }

  Future<void> _initAmmoniaBuilding() async {
    final ammoniaBuildingData = await dbHelper.getAllWhr(
      tbl: tableBuildings,
      where: 'resource_type = ?',
      whereArgs: [
        'ammonia',
      ],
    );
    if (ammoniaBuildingData.isNotEmpty) {
      ammoniaBuilding.value = ResourceBuilding.fromJson(
        ammoniaBuildingData[0],
      );
      ammonia = ammoniaBuilding.value!.resource;
    }
  }

  Future<void> _initWaterBuilding() async {
    final waterBuildingData = await dbHelper.getAllWhr(
      tbl: tableBuildings,
      where: 'resource_type = ?',
      whereArgs: [
        'water',
      ],
    );
    if (waterBuildingData.isNotEmpty) {
      waterBuilding.value = ResourceBuilding.fromJson(
        waterBuildingData[0],
      );
      water = waterBuilding.value!.resource;
    }
  }

  Future<void> upgradeObject({
    required Rx<ResourceBuilding?> building,
  }) async {
    if (building.value == null) return;
    Get.dialog(
      ResourceUpgraderDialoge(
        object: building.value!.resource,
        building: building.value!,
        onUpgrade: () async {
          if (await building.value!.upgradeBuilding()) {
            final confirmation = await confirmationModal(
              msg:
                  'Are you sure you want to upgrade ${building.value!.resource.name} building?',
            );
            if (confirmation) {
              await insertBuilding(
                building: building,
              );
              await onInit();
              building.refresh();
              Get.back();
            }
          } else {
            toast(
              'Not enough resources to upgrade ${building.value!.resource.name} building.',
            );
          }
        },
      ),
    );
  }

  void goToShop() {
    Get.toNamed(Routes.shopPage);
  }

  Future<void> insertBuilding({
    required Rx<ResourceBuilding?> building,
  }) async {
    await dbHelper.updateWhere(
      tbl: tableBuildings,
      where: 'resource_type = ?',
      whereArgs: [
        building.value!.resourceType,
      ],
      data: building.value!.toJson(),
    );
  }

  Future<void> clearBuilding() async {
    await dbHelper.deleteAll(
      tbl: tableBuildings,
    );
    methaneBuilding.value = null;
    hydrogenSulfideBuilding.value = null;
    ammoniaBuilding.value = null;
    waterBuilding.value = null;
    Get.offAllNamed(Routes.splashPage);
  }

  Future<void> buildBuilding() async {
    await dbHelper.getAll(tbl: tableBuildings).then(
      (value) {
        final upgradeRequirements =
            jsonDecode(value.first['upgrade_requirements']);
        upgradeRequirements.forEach(
          (key, value) {
            print('key: $key, value: $value');
            final x = Resource.fromJson(value);
            print('Resource: ${x.toJson()}');
          },
        );
        ResourceBuilding.fromJson(value[0]);
      },
    );
  }

  Future<void> produceResource({
    required Rx<ResourceBuilding?> building,
  }) async {
    if (building.value == null) return;
    building.value!.produceResource();
    await dbHelper.updateWhere(
      tbl: tableBuildings,
      data: building.toJson(),
      where: 'resource_type = ?',
      whereArgs: [building.value!.resourceType],
    );
    await Get.forceAppUpdate();
  }
}
