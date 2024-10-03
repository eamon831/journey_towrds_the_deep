import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';
import '/app/entity/resource.dart';
import '/app/entity/resource_building.dart';

// ResourceBuilding class that manages resource generation and upgrades

final methane = Resource(
  name: 'Methane',
  slug: 'methane',
  description: 'Methane is a chemical compound with the chemical formula CH4.',
  image: 'assets/lottie/mountain.json',
  type: 'Gas',
);

final hydrogenSulfide = Resource(
  name: 'Hydrogen Sulfide',
  slug: 'hydrogen-sulfide',
  description:
      'Hydrogen sulfide is a colorless gas with the characteristic foul odor of rotten eggs.',
  image: 'assets/lottie/mountain.json',
  type: 'Gas',
);

final ammonia = Resource(
  name: 'Ammonia',
  slug: 'ammonia',
  description:
      'Ammonia is a compound of nitrogen and hydrogen with the formula NH3.',
  image: 'assets/lottie/mountain.json',
  type: 'Liquid',
);

final methaneBuilding = ResourceBuilding(
  resource: methane,
  resourceType: 'methane',
  upgradeRequirements: {
    hydrogenSulfide: 30,
  },
).obs;

final hydrogenSulfideBuilding = Rx<ResourceBuilding?>(null);

final ammoniaBuilding = Rx<ResourceBuilding?>(null);

class PlanetController extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();

    await _init();

    await _initHydrogenSulfideBuilding();

    await _initAmmoniaBuilding();

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
    } else {
      await dbHelper.insertList(
        deleteBeforeInsert: false,
        tableName: tableBuildings,
        dataList: [methaneBuilding.value.toJson()],
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
    }
  }

  Future<void> upgradeObject({
    required Rx<ResourceBuilding?> building,
  }) async {
    if(building.value == null) return;
    Get.dialog(
      ResourceUpgraderDialoge(
        object: building.value!.resource,
        onUpgrade: () async {
          final confirmation = await confirmationModal(
            msg:
                'Are you sure you want to upgrade ${building.value!.resource.name} building?',
          );
          if (confirmation) {
            if (building.value!.upgradeBuilding()) {
              await insertBuilding(
                building: building,
              );
              building.refresh();
              Get.back();
            } else {
              toast(
                'Not enough resources to upgrade ${building.value!.resource.name} building.',
              );
            }
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
}
