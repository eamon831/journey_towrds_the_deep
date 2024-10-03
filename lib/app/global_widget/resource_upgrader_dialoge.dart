
import '/app/entity/resource.dart';

import '/app/core/exporter.dart';

class ResourceUpgraderDialoge extends StatelessWidget {
  final Resource object;
  final VoidCallback onUpgrade;
  const ResourceUpgraderDialoge({
    required this.object,
    required this.onUpgrade,
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
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: Lottie.asset(
                object.image,
                width: Get.width * 0.05,
                height: Get.height * 0.05,
                fit: BoxFit.cover,
              ),
            ),
            // upgrade button
            ElevatedButton(
              onPressed: onUpgrade,
              child: const Text('Upgrade'),
            ),
          ],
        ),
      ),
    );
  }
}
