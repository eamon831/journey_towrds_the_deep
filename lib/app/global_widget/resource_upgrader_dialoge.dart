import 'package:getx_template/app/entity/resource_building.dart';

import '/app/entity/resource.dart';

import '/app/core/exporter.dart';

class ResourceUpgraderDialoge extends StatelessWidget {
  final Resource object;
  final VoidCallback onUpgrade;
  final ResourceBuilding building;
  const ResourceUpgraderDialoge({
    required this.object,
    required this.onUpgrade,
    required this.building,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DialogPattern(
      title: object.name,
      subTitle: object.type,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(object.description),
            // upgrade button

            Row(
              mainAxisAlignment: spaceBetweenMAA,
              children: [
                Column(
                  mainAxisAlignment: startMAA,
                  crossAxisAlignment: startCAA,
                  children: [
                    const Text(
                      'Next Upgrade Cost',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      children: building.upgradeRequirements.entries.map(
                        (entry) {
                          return Chip(
                            label: Text('${entry.key.name}: ${entry.value}'),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
                IconTextButton(
                  onTap: onUpgrade,
                  text: 'Upgrade',
                  icon: TablerIcons.hammer,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
