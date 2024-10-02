import 'package:nb_utils/nb_utils.dart';

import '/app/core/exporter.dart';

// Resource class represents a resource like Methane, Sulfur, etc.
class Resource {
  final String name;
  final String slug;
  final String description;
  final String image;
  final String type;
  int currentCount;

  Resource({
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.type,
    this.currentCount = 0,
  });
}

// ResourceBuilding class that manages resource generation and upgrades
class ResourceBuilding {
  final Resource resource; // The resource this building generates
  int productionRate; // Rate at which the building generates the resource
  int currentLevel;
  final int maxLevel;
  Map<Resource, int> upgradeRequirements;

  ResourceBuilding({
    required this.resource,
    this.productionRate = 10, // Default production rate per time unit
    this.currentLevel = 1,
    this.maxLevel = 5,
    Map<Resource, int>? upgradeRequirements,
  }) : upgradeRequirements = upgradeRequirements ?? {};

  // Method to produce resources based on current production rate
  void produceResource() {
    resource.currentCount += productionRate;
  }

  // Method to upgrade the building to increase production rate
  bool upgradeBuilding() {
    if (currentLevel < maxLevel) {
      // Check if upgrade requirements are met
      if (_canUpgrade()) {
        currentLevel++;
        // increase production rate by 10% for each level
        // productionRate += 10; // Increase production rate with each upgrade
        productionRate = (productionRate * 1.1).toInt();
        _increaseUpgradeRequirements();
        _deductResourcesForUpgrade();
        print(
          '${resource.name} Building upgraded to level $currentLevel. New production rate: $productionRate',
        );
        return true;
      } else {
        print('Not enough resources to upgrade ${resource.name} Building.');
        return false;
      }
    } else {
      print('${resource.name} Building is already at max level.');
      return false;
    }
  }

  // Check if the building can be upgraded (enough resources available)
  bool _canUpgrade() {
    for (final entry in upgradeRequirements.entries) {
      if (entry.key.currentCount < entry.value) {
        return false;
      }
    }
    return true;
  }

  // Deduct the resources used for upgrading
  void _deductResourcesForUpgrade() {
    for (final entry in upgradeRequirements.entries) {
      entry.key.currentCount -= entry.value;
    }
  }

  // Increase the upgrade requirements based on current level
  void _increaseUpgradeRequirements() {
    // For each resource requirement, increase the amount required
    upgradeRequirements.updateAll((resource, amount) {
      return (amount * 1.5).toInt(); // Increase by 50% for each level
    });

    print('New upgrade requirements for level $currentLevel:');
    upgradeRequirements.forEach((resource, amount) {
      print('${resource.name}: $amount');
    });
  }
}

final methane = Resource(
  name: 'Methane',
  slug: 'methane',
  description: 'Methane is a chemical compound with the chemical formula CH4.',
  image: 'assets/lottie/mountain.json',
  type: 'Gas',
);

final sulfur = Resource(
  name: 'Sulfur',
  slug: 'sulfur',
  description:
      'Sulfur is a chemical element with the symbol S and atomic number 16.',
  image: 'assets/lottie/mountain.json',
  type: 'Solid',
);

final methaneBuilding = ResourceBuilding(
  resource: methane,
  productionRate: 1,
  upgradeRequirements: {
    sulfur: 30,
  },
).obs;

final sulfurBuilding = ResourceBuilding(
  resource: sulfur,
  productionRate: 1,
  upgradeRequirements: {
    methane: 35,
  },
).obs;

class PlanetController extends BaseController {
  final methaneCount = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
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
              building.refresh();
              Get.back();
            } else {
              toast(
                  'Not enough resources to upgrade ${building.value.resource.name} building.');
            }
          }
        },
      ),
    );
  }
}
