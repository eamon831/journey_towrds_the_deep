import 'dart:convert';

import 'package:getx_template/app/core/exporter.dart';

import 'resource.dart';

class ResourceBuilding {
  final Resource resource;
  int productionRate;
  int currentLevel;
  final int maxLevel;
  final String? resourceType;
  Map<Resource, int> upgradeRequirements;
  num currentCount;

  ResourceBuilding({
    required this.resource,
    required this.resourceType,
    this.productionRate = 10, // Default production rate per time unit
    this.currentLevel = 1,
    this.maxLevel = 15,
    Map<Resource, int>? upgradeRequirements,
    required this.currentCount,
  }) : upgradeRequirements = upgradeRequirements ?? {};

  factory ResourceBuilding.fromJson(Map<String, dynamic> json) {
    // Decode the upgrade requirements from JSON and create a Map<Resource, int>
    final decodedUpgradeRequirements = jsonDecode(
      json['upgrade_requirements'],
    ) as Map<String, dynamic>;

    final Map<Resource, int> upgradeRequirements =
        decodedUpgradeRequirements.map(
      (key, value) {
        return MapEntry(
          Resource.fromJson(value),
          int.parse(key),
        );
      },
    );

    return ResourceBuilding(
      resource: json['resource'] is String
          ? Resource.fromJson(jsonDecode(json['resource']))
          : Resource.fromJson(json['resource']),
      productionRate: json['production_rate'],
      currentLevel: json['current_level'],
      maxLevel: json['max_level'],
      resourceType: json['resource_type'],
      upgradeRequirements: upgradeRequirements,
      currentCount: json['current_count'],
    );
  }

  // Method to produce resources based on current production rate
  void produceResource() {
    resource.currentCount += productionRate;
    currentCount = resource.currentCount;
  }

  // Method to upgrade the building to increase production rate
  Future<bool> upgradeBuilding() async {
    if (currentLevel < maxLevel) {
      // Check if upgrade requirements are met
      if (await _canUpgrade()) {
        currentLevel++;
        // increase production rate by 10% for each level
        // productionRate += 10; // Increase production rate with each upgrade
        productionRate = (productionRate * 1.1).toInt();
        await _deductResourcesForUpgrade();
        _increaseUpgradeRequirements();

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
  Future<bool> _canUpgrade() async {
    final dbHelper = DbHelper.instance;
    final keys = upgradeRequirements.keys.toList();

    for (final key in keys) {
      final data = await dbHelper.getAllWhr(
        tbl: tableBuildings,
        where: 'resource_type = ?',
        whereArgs: [
          key.slug,
        ],
      );
      if(data.isEmpty) return false;

      if (data[0]['current_count'] < upgradeRequirements[key]!) {
        return false;
      }
    }

    return true;
  }

  // Deduct the resources used for upgrading
  Future<void> _deductResourcesForUpgrade() async {
    for (final entry in upgradeRequirements.entries) {
      entry.key.currentCount -= entry.value;
    }
    // deduct resources from the player's inventory
    final dbHelper = DbHelper.instance;

    final keys = upgradeRequirements.keys.toList();

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
        final newCount = currentCount - upgradeRequirements[key]!;
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

  // Increase the upgrade requirements based on current level
  void _increaseUpgradeRequirements() {
    // For each resource requirement, increase the amount required
    upgradeRequirements.updateAll(
      (resource, amount) {
        return (amount * 1.5).toInt(); // Increase by 50% for each level
      },
    );

    print('New upgrade requirements for level $currentLevel:');
    upgradeRequirements.forEach(
      (resource, amount) {
        print('${resource.name}: $amount');
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resource': jsonEncode(resource.toJson()),
      'production_rate': productionRate,
      'current_level': currentLevel,
      'max_level': maxLevel,
      'resource_type': resourceType,
      'upgrade_requirements': jsonEncode(
        upgradeRequirements.map(
          (key, value) {
            return MapEntry(
              value.toString(),
              key.toJson(),
            );
          },
        ),
      ),
      'current_count': currentCount,
    };
  }
}
