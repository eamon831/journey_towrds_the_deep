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
  productionRate: 1,
  resourceType: 'methane',
  upgradeRequirements: {
    hydrogenSulfide: 30,
  },
).obs;

final hydrogenSulfideBuilding = ResourceBuilding(
  resource: hydrogenSulfide,
  productionRate: 1,
  resourceType: 'hydrogen-sulfide',
  upgradeRequirements: {
    methane: 35,
  },
).obs;

final ammoniaBuilding = ResourceBuilding(
  resource: ammonia,
  productionRate: 1,
  resourceType: 'ammonia',
  upgradeRequirements: {
    methane: 40,
    hydrogenSulfide: 40,
  },
).obs;

class PlanetController extends BaseController {
  final hasHydrogenSulfide = RxBool(false);
  final hasAmmonia = RxBool(false);
  @override
  Future<void> onInit() async {
    super.onInit();
    hasHydrogenSulfide.value = await prefs.getBool(prefHasHydrogenSulfide);
    hasAmmonia.value = await prefs.getBool(prefHasAmmonia);
    await _initMethaneBuilding();
    if (hasHydrogenSulfide.value) {
      await _initHydrogenSulfideBuilding();
    }
    if (hasAmmonia.value) {
      await _initAmmoniaBuilding();
    }

    methaneBuilding.refresh();
  }

  Future<void> _initMethaneBuilding() async {
    final count = await prefs.getInt(prefMethaneCount);
    if (count != null) {
      methaneBuilding.value.resource.currentCount = count;
    }
  }

  Future<void> _initHydrogenSulfideBuilding() async {
    final count = await prefs.getInt(prefHydrogenSulfideCount);
    if (count != null) {
      hydrogenSulfideBuilding.value.resource.currentCount = count;
    }
  }

  Future<void> _initAmmoniaBuilding() async {
    final count = await prefs.getInt(prefAmmoniaCount);
    if (count != null) {
      ammoniaBuilding.value.resource.currentCount = count;
    }
  }

  Future<void> upgradeObject({
    required Rx<ResourceBuilding> building,
  }) async {
    Get.dialog(
      ResourceUpgraderDialoge(
        object: building.value.resource,
        onUpgrade: () async {
          final confirmation = await confirmationModal(
            msg:
                'Are you sure you want to upgrade ${building.value.resource.name} building?',
          );
          if (confirmation) {
            if (building.value.upgradeBuilding()) {
              await insertBuilding(
                building: building,
              );
              building.refresh();
              Get.back();
            } else {
              toast(
                'Not enough resources to upgrade ${building.value.resource.name} building.',
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
    required Rx<ResourceBuilding> building,
  }) async {
    await dbHelper.updateWhere(
      tbl: tableBuildings,
      where: 'resource_type = ?',
      whereArgs: [
        building.value.resourceType,
      ],
      data: building.value.toJson(),
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
